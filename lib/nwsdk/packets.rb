module Nwsdk
  class Packets
    include Helpers

    attr_accessor :group, :file_prefix, :query, :endpoint, :condition

    def initialize(*args)
      Hash[*args].each {|k,v| self.send("%s="%k, v)}
      @group       ||= 1000
      @file_prefix ||= "pcap"
      @query       ||= Nwsdk::Query.new(keys: %w{ sessionid })
    end

    def request
      pcaps={}
      each_pcap_group do | group |
        pcaps[group[:filename]]=data
      end
      pcaps
    end

    def build_request(sessions=[])
      endpoint.get_request(
        path: 'sdk/packets',
        params: {
          sessions: sessions.join(',')
        }
      )
    end

    def get_pcap_data(sessions=[])
      build_request(sessions).execute
    end

    def each_pcap_group
      sessions=get_sessionids(self)
      sessions_digits=sessions.size.to_s.length
      session_counter=0
      session_stamp=Time.new.to_i
      fformat="%s_%0#{sessions_digits}d-%0#{sessions_digits}d.pcap"
      sessions.each_slice(group) do |slice|
        sstart=session_counter
        ssend = sstart + slice.size - 1
        fname=sprintf(fformat, file_prefix, sstart, ssend)
        data=get_pcap_data(slice)
        yield pcap_group={
          group_start: sstart,
          group_end:   ssend,
          filename:    fname,
          data:        data
        }
        session_counter += slice.size
      end
    end
  end
end
