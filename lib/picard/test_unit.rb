module Picard
  PREPROCESSOR = Picard::Preprocessor.new
  MESSAGE_FORMATTER = ErrorMessageFormatter.new

  module InstanceMethods
    def given
    end

    def expect
    end

    def picard_format_error_message line, lineno
      context = extract_saved_context_from_class
      context.lineno = lineno
      Picard::MESSAGE_FORMATTER.format_message line, context
    end

    private
    def extract_saved_context_from_class
      self.class.send(Picard::Preprocessor::CONTEXT_METHOD_NAME)
    end
  end

  module ClassMethods
    def method_added name
      preprocess_add_method name
    end

    private
    def preprocess_add_method name
      Picard::PREPROCESSOR.preprocess_method self, name
    end
  end

  module TestUnit
    def self.included clazz
      context = Picard::Context.new(caller)
      save_context clazz, context

      clazz.send :include, InstanceMethods
      clazz.send :extend, ClassMethods
    end

    private
    def self.save_context clazz, context
      Picard::PREPROCESSOR.generate_context_method clazz, context
    end
  end
end