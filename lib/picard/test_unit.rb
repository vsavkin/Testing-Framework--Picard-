module Picard
  PREPROCESSOR = Picard::Preprocessor.new
  
  module InstanceMethods
    def given
    end

    def expect
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
      clazz.send :include, InstanceMethods
      clazz.send :extend, ClassMethods
    end
  end
end