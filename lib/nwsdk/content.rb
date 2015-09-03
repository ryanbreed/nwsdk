module Nwsdk
  class Content
    include Helpers
    include Constants

    attr_accessor :output_dir, :include_types, :exclude_types,
      :condition, :endpoint

    def initialize(*args)
      Hash[*args].each {|k,v| self.send('%s='%k, v)}
      @include_types ||= []
      @exclude_types ||= []
      @output_dir    ||= 'tmp'
    end

    def build_request(session)
      endpoint.get_request(
        path: 'sdk/content',
        params: build_params(session)
      )
    end

    def each_session
      sessions=get_sessionids(self)
      sessions.each do |sessionid|
        begin
          response=build_request(sessionid).execute
        rescue RestClient::Gone
          next
        end
        next unless response.code==200
        yield response
      end
    end

    def each_session_file
      each_session do |response|
        content=response.body.encode('BINARY')
        next unless response.headers.has_key? :content_type
        boundary=get_boundary(response.headers[:content_type])
        each_multipart_response_entity(content,boundary) do |file|
          yield file
        end
      end
    end

    def build_params(session)
      send_params={
        session: session,
        maxSize: 0,
        render:  NW_CONTENT_TYPE_FILE_EXTRACTOR
      }
      unless include_types.empty?
        send_params[:includeFileTypes]=include_types.join(';')
      end
      unless exclude_types.empty?
        send_params[:excludeFileTypes]=exclude_types.join(';')
      end
      send_params
    end

  end
end
