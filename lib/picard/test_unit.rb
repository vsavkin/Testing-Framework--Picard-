module Picard
  module DummyMethods
    def given
    end

    def expect
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
      clazz.send :include, DummyMethods
      clazz.send :extend, ClassMethods
    end
  end
end