module Picard
  module InstanceMethods
    def given
    end

    def expect
    end

    def picard_format_error_message message
      message
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
      save_meta_information clazz
      clazz.send :include, InstanceMethods
      clazz.send :extend, ClassMethods
    end

    private
    def self.save_meta_information clazz
      context = Picard::Context.new
      Picard::Preprocessor.new.generate_context_method clazz, context
    end
  end
end