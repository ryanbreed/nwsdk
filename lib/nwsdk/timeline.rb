module Nwsdk
  class Timeline
    include Helpers

    attr_accessor :flags, :condition, :endpoint, :limit

    def initialize(*args)
      Hash[*args].each {|k,v| self.send("%s="%k, v)}
      @limit ||= 10000
      @flags ||= %w{ size }
    end

    def request
      result=build_request.execute
      if response_successful?(result)
        res=count_results(JSON.parse(result))
        keys=res.keys.map {|k| k - k.gmtoff}
        Hash[keys.zip(res.values)]
      else
        result
      end
    end

    def build_request
      endpoint.get_request(
        path: 'sdk',
        params: build_params
      )
    end
    def build_params
      
      params={
        msg: 'timeline',
        time1: format_timestamp(condition.time1),
        time2: format_timestamp(condition.time2),
        size:  limit,
        timezone: 0,
        flags: flags.join(','),
      }
      if condition.where.nil?
        params
      else
        params.merge(where: condition.format(use_time: false))
      end
    end

  end
end
