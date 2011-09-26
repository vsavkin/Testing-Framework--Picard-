require 'live_ast'
require 'live_ast/to_ruby'
require 'ruby2ruby'

module Picard
  class Preprocessor
    META_INFO_METHOD_NAME = :picard_meta_info

    def initialize class_ripper = ClassRipper.new, method_ripper = MethodRipper.new
      @class_ripper = class_ripper
      @method_ripper = method_ripper
      @preprocessed_methods = []
    end

    def generate_context_method clazz, context
      @class_ripper.save_meta_info clazz, META_INFO_METHOD_NAME, context
    end

    def preprocess_class clazz
      all_test_methods = @class_ripper.all_test_method_names(clazz)
      all_test_methods.each do |m|
        preprocess_method clazz, m
      end
    end

    def preprocess_method clazz, method_name
      return if preprocessed?(method_name)
      return unless @class_ripper.test_method?(method_name)
      
      mark_as_preprocessed method_name
      replace_method_with_preprocessed clazz, method_name
    end

    private

    def replace_method_with_preprocessed clazz, method_name
      method = clazz.instance_method(method_name)
      new_method_str = @method_ripper.wrap_all_assertions(method)
      @class_ripper.replace_method clazz, new_method_str
    end

    def preprocessed? method_name
      @preprocessed_methods.include? method_name
    end
    
    def mark_as_preprocessed method_name
      @preprocessed_methods << method_name
    end
  end
end