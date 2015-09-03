module Nwsdk
  module Helpers
    MULTIPART_BOUNDARY=%r{\Amultipart/mixed; boundary="(?<msg_boundary>.+)"\z}
    MULTIPART_PROLOGUE=%r{\AThis is a message with multiple parts in MIME format.}
    MULTIPART_END=%r{\A--\z}
    ATTACHMENT_FILENAME=%r{\Aattachment; filename="(?<filename>.+)"\z}

    def decode_value(field)
      case field['format']
      when 1,2,3,4,5,6,7,8,9,34
          field['value'].to_i
        when 10,11
          field['value'].to_f
        when 32
          t=Time.at(field['value'].to_i)
          t + t.gmtoff
        when 33
          Nwsdk::Constants::NW_VARIANT_DAYS[field['value'].to_i]
        when 128,129
          IPAddr.new(field['value'])
        else
          field['value']
      end
    end
    def format_timestamp(time)
      time.getutc.strftime(Nwsdk::Constants::NW_TIME_FORMAT)
    end

    def response_successful?(response)
      response.code==200 && response.net_http_res.content_type == 'application/json'
    end

    def get_sessionids(restq)
      session_query=Nwsdk::Query.new(keys: ['sessionid'], condition: restq.condition, endpoint: restq.endpoint)
      result=session_query.request
      result.map {|r| r['sessionid']}
    end

    def get_boundary(header_val)
      header_val.match(MULTIPART_BOUNDARY)[:msg_boundary]
    end

    def count_results(result)
      fields=result['results'].fetch('fields',[])
      fields.reduce({}) do |memo,field|
        val=decode_value(field)
        memo[val]=field['count']
        memo
      end
    end

    def each_multipart_response_entity(data, boundary=nil)

      data.force_encoding('BINARY').split('--'+ boundary).each do |entity|
        cleaned=entity.strip
        next if (cleaned.match(MULTIPART_PROLOGUE) || cleaned.match(MULTIPART_END))
        header_lines,sep,entity_data=cleaned.partition(%r{\r\n\r\n})
        headers=Hash[header_lines.split(%r{\r\n}).map {|l| l.split(%r{: })}]
        filename=headers['Content-Disposition'].match(ATTACHMENT_FILENAME)[:filename]
        yield file_hash={
          filename: filename,
          type:     headers['Content-Type'],
          size:     headers['Content-Length'].to_i,
          data:     entity_data
        }
      end
    end

  end
end
