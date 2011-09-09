module Picard
  module InstanceMethods
    def given
    end

    def expect
    end

    def picard_format_error_message message
      'message'
    end
  end

  module ClassMethods
    def method_added name
      @tr ||= Picard::Preprocessor.new
      @tr.preprocess_method self, name
    end
  end

  module TestUnit
    def self.included clazz
      clazz.send :include, InstanceMethods
      clazz.send :extend, ClassMethods
    end
  end
end