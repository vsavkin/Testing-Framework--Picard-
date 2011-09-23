module Picard
  Context = Struct.new(:file, :lineno)

  module InstanceMethods
    def given
    end

    def expect
    end

    def picard_format_error_message line, lineno
      formatter = ErrorMessageFormatter.new
      context = self.class.picard_meta_info
      context.lineno = lineno
      formatter.format_message line, context
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
      file = caller[1].split(':')[0]
      context = Picard::Context.new(file)
      Picard::Preprocessor.new.generate_context_method clazz, context
    end
  end
end