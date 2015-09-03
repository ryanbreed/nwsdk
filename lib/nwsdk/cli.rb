require 'thor'
require 'chronic'
require 'nwsdk'
require 'cef'
require 'fileutils'

module Nwsdk
  def self.setup_cli(options, where)
    endpoint=Nwsdk::Endpoint.configure(options[:config])
    e=case options[:end]
      when nil?
        options[:start] + options[:span]
      else
        Chronic.parse(options[:end])
    end



    condition=Nwsdk::Condition.new(
      where: where,
      start: Chronic.parse(options[:start]),
      end:   e,
      span:  options[:span]
    )
    { endpoint: endpoint, condition: condition }
  end

  class Cli < Thor
    now=Time.new
    class_option :config,
      default: File.join(ENV['HOME'],'.nwsdk.json'),
      desc:    'JSON file with endpoint info & credentials'
    class_option :host,
      desc:      'hostname for broker or concentrator',
      default: ENV['NW_HOST']
    class_option :port,
      type: :numeric,
      desc:    'REST port for broker/concentrator',
      default: 50103
    # TODO: fix this
    class_option :span,
      type: :numeric,
      default: 3600,
      desc: 'max timespan in seconds'
    class_option :limit,
      type: :numeric,
      default: 10000,
      desc: 'max number of sessions'
    # TODO: fix this
    class_option :start,
      desc: 'start time for query',
      type: :string,
      default: (now - 3600).strftime('%Y-%m-%d %H:%M:%S')

    class_option :end,
      desc: 'end time for query',
      type: :string
    class_option :debug,
      type: :boolean,
      default: false,
      desc: 'extra info'


    desc 'timeline', 'get a time-indexed histogram of sessions/packets/bytes'
    option :where,
      desc: 'search condition, e.g. ip.src=1.1.1.1&&service=0',
      type: :string
    option :flags,
      type: :string,
      default: 'size',
      desc: 'comma-separated list of sessions, size, packets, order-ascending, order-descending'
    def timeline
      flags=options[:flags].split(',')
      timeline=Nwsdk::Timeline.new(Nwsdk.setup_cli(options,options[:where]).merge(flags: flags))
      result=timeline.request
      puts JSON.pretty_generate(result)
    end

    desc 'values CONDITIONS', 'get value report for specific meta key'
    option :size,
      type: :numeric,
      default: 100,
      desc: 'limit to this number of results'
    option :key_name,
      type: :string,
      default: 'service',
      desc: 'meta key name'
    option :where,
      desc: 'search condition, e.g. ip.src=1.1.1.1&&service=0',
      type: :string
    option :flags,
      default: 'sort-total,sessions,order-descending',
      type: :string,
      desc: 'comma-separated combindation of sessions, size, packets, sort-total, sort-value, order-ascending, order-descending'
    def values
      flags=options[:flags].split(',')
      vals=Nwsdk::Values.new(Nwsdk.setup_cli(options,where=options[:where]))
      vals.key_name=options[:key_name]
      vals.limit=options[:size]
      vals.flags=flags
      result=vals.request
      puts JSON.pretty_generate(result)
    end

    desc 'query CONDITIONS', 'execute SDK query'
    option :keys, default: '*', desc: 'comma-separated list of meta keys to include'
    def query(where)
      nwq=Nwsdk::Query.new(Nwsdk.setup_cli(options,where))
      nwq.keys=options[:keys].split(',')
      result=nwq.request
      puts JSON.pretty_generate(result)
    end

    desc 'content CONDITIONS', 'extract files for given query conditions'
    option :dir,   default: 'tmp', desc: 'output directory'
    option :exclude, default: '', desc: 'comma-separated list of file extensions to exclude'
    option :include, default: '', desc: 'include only this comma-separated list of extensions'
    def content(where)
      content=Nwsdk::Content.new(Nwsdk.setup_cli(options,where))
      content.output_dir=options[:dir]
      incl=options[:include].split(',')
      excl=options[:exclude].split(',')
      content.include_types=incl unless incl==[]
      content.exclude_types=excl unless excl==[]
      content.each_session_file do |file|
        FileUtils.mkdir_p(options[:dir]) unless Dir.exist?(options[:dir])
        outf=File.join(options[:dir],file[:filename])
        STDERR.puts "writing #{outf}"
        File.open(outf,'w') {|f| f.write(file[:data]) }
      end
    end

    desc 'pcap CONDITIONS', 'extract PCAP for given query conditions'
    option :prefix, default: 'pcap_%08d' % $$, desc: 'file name prefix'
    option :group, type: :numeric, desc: 'max sessions per pcap file', default: 1000
    def pcap(where)
      p=Nwsdk::Packets.new(Nwsdk.setup_cli(options,where))
      p.group=options[:group]
      p.file_prefix=options[:prefix]
      p.each_pcap_group do |g|
        STDERR.puts "Writing #{g[:filename]}"
        File.open(g[:filename],'w') {|f| f.write(g[:data])}
      end
    end

    desc 'cef CONDITIONS', 'send cef alerts for query conditions'
    option :name,
      desc:    'name of event',
      default: 'cef alert'
    option :loghost,
      required: true,
      desc: 'syslog destination'
    option :logport,
      default: 514,
      type:    :numeric,
      desc: 'syslog UDP port'
    def cef(where)
      nwq = Nwsdk::Query.new(Nwsdk.setup_cli(options,where))
      nwq.keys = ['*']
      result  = nwq.request

      mapping = nwq.endpoint.config['cef_mapping']

      sender = case nwq.endpoint.loghost
        when nil
          CEF::UDPSender.new(options[:loghost],options[:logport])
        else
          CEF::UDPSender.new(*nwq.endpoint.loghost)
      end

      result.each do |res|
        event=CEF::Event.new
        event_fields=mapping.keys & res.keys
        event_fields.each do |field|
          event.send('%s=' % mapping[field],res[field].to_s)
        end
        nwq.endpoint.config['cef_static_fields'].each {|k,v| event.send('%s='%k,v)}
        event.name=options[:name]
        event.endTime=(res['time'].to_i * 1000).to_s
        puts event.to_s
        sender.emit(event)
      end
    end

    config=File.join(ENV['HOME'],'.nwsdk.json')
    desc 'configure /path/to/config.json', 'write out a template configuration file'
    option :user,
      default: 'admin',
      desc: 'username with sdk query rights'
    option :pass,
      default: 'netwitness',
      desc: 'password'
    option :loghost,
      desc: 'syslog destination for cef alerts'
    option :logport,
      default: 514,
      type:    :numeric,
      desc: 'syslog UDP port'
    def configure(path=File.join(ENV['HOME'],'.nwsdk.json'))
      conf=Nwsdk::Constants::DEFAULT_CONFIG.dup
      conf['endpoint']['host']=options[:host] unless options[:host].nil?
      conf['endpoint']['port']=options[:port]
      conf['endpoint']['user']=options[:user]
      conf['endpoint']['pass']=options[:pass]
      conf['syslog']['loghost']=options[:loghost] unless options[:loghost].nil?
      conf['syslog']['logport']=options[:logport]
      File.open(path,'w') {|f| f.write JSON.pretty_generate(conf) }
    end
  end
end
