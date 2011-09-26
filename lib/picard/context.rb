module Picard
  class Context
    attr_accessor :file, :lineno

    def initialize caller
      @file = parse_current_filename(caller)
    end

    private

    def parse_current_filename caller
      return "" if caller.empty?

      last_call = caller[0]
      return "" if last_call.split(':').empty?

      last_call.split(':')[0]
    end

  end
end