module Nwsdk
  class Endpoint
    attr_accessor :host, :port, :user, :pass, :config, :save_request
    def self.configure(conf=File.join(ENV["HOME"],".nwsdk.json"))
      config=JSON.parse(File.read(conf))
      endpoint=Nwsdk::Endpoint.new(config["endpoint"])
      endpoint.config=config
      endpoint
    end

    def initialize(*args)
      Hash[*args].each {|k,v| self.send("%s=" % k, v) }
      @port ||= 50103
      @save_request||=false
      yield self if block_given?
      self
    end

    def type=(type_sym)
      @port=case type_sym
        when :broker
          50103
        when :decoder
          50104
        when :concentrator
          50105
        else
          raise ArgumentError, "invalid endpoint type #{type_sym.to_s}"
      end
    end

    def uri(path='sdk')
      sprintf('https://%s:%d/%s', host, port, path)
    end

    def get_request(path: 'sdk', params: {})
      req=RestClient::Request.new(
        method:     :get,
        url:        uri(path),
        user:       user,
        password:   pass,
        read_timenout: nil,
        verify_ssl: OpenSSL::SSL::VERIFY_NONE,
        payload: params,
        headers:  {
          "Accept-Encoding" => :deflate,
          accept: :json,
        }
      )
    end

    def loghost
      if config.has_key?("syslog")
        [ config["syslog"]["loghost"], config["syslog"]["logport"]]
      else
        nil
      end
    end
  end
end
