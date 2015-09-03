module Nwsdk
  class Query
    include Helpers

    attr_accessor :limit, :keys, :id1, :id2, :endpoint, :condition

    def initialize(*args)
      Hash[*args].each {|k,v| self.send("%s="%k, v)}
      @limit   ||= 10000
      @keys    ||= %w{ * }
    end

    def request
      result=build_request.execute
      if response_successful?(result)
        unroll_result(JSON.parse(result))
      else
        result
      end
    end

    def build_request
      endpoint.get_request(
        path: 'sdk',
        params:   {
          msg:   'query',
          query: format_select,
          size:  limit * width
        }
      )
    end

    def width
      if keys==["*"]
        100
      else
        keys.size
      end
    end

    def format_select
      sprintf("select %s where %s", keys.join(','), condition.format)
    end

    def unroll_result(result)
      grouped=result["results"]["fields"].group_by {|f| f["group"] }
      grouped.map do |gid,fields|
        report=Hash.new
        fields.each do |field|
          key = field["type"]
          val = decode_value(field)
          if report.has_key?(key)
            report[key]=[*report[key],val]
          else
            report[key]=val
          end
        end
        report
      end
    end
  end
end
