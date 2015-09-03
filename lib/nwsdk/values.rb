module Nwsdk
  class Values
    include Helpers

    attr_accessor :key_name, :flags, :limit, :condition, :endpoint

    def initialize(*args)
      Hash[*args].each {|k,v| self.send("%s="%k, v)}
      @flags    ||= %w{ sort-total sessions order-descending }
      @limit    ||= 10000
      @key_name ||= 'service'
    end

    def build_request
      endpoint.get_request(
        path: 'sdk',
        params: {
          msg:       'values',
          where:     condition.format(use_time: false),
          time1:     format_timestamp(condition.time1.utc),
          time2:     format_timestamp(condition.time2.utc),
          size:      limit,
          flags:     flags.join(','),
          fieldName: key_name
        }
      )
    end

    def request
      result=build_request.execute
      if response_successful?(result)
        count_results(JSON.parse(result))
      else
        result
      end
    end
  end
end
