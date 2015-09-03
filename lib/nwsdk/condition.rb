module Nwsdk
  class Condition
    include Helpers
    attr_accessor :where, :start, :end, :span, :id1, :id2, :tz_offset

    def initialize(*args)
      Hash[*args].each {|k,v| self.send("%s="%k, v)}
      init = Time.new

      # TODO: this is hella ugly, mane
      if @end.nil?
        @span ||= 3600
        if @start.nil?
          @end=init
          @start=@end - @span
        else
          @end = @start + @span
        end
      else
        if @start.nil?
          @span ||= 3600
          @start = @end - @span
        else
          @span = @end - @start
        end

      end
      @tz_offset = @start.gmtoff
    end

    def format(use_time: true)
      formatted_where=case where
        when nil
          ""
        else
          sprintf('(%s)',where)
      end
      if use_time
        if formatted_where==""
          sprintf('time=%s', format_time_range)
        else
          sprintf('%s&&time=%s',formatted_where,format_time_range)
        end
      else
        formatted_where
      end
    end

    def format_time_range
      sprintf("'%s'-'%s'",
        format_timestamp(@start),
        format_timestamp(@end)
      )
    end

    # alias for #start

    def time1=(t)
      @start=t
    end

    def time1
      @start
    end

    # alias for #end

    def time2=(t)
      @end=t
    end

    def time2
      @end
    end
  end
end
