module Picard
  class ClassRipper
    def test_method? method_name
      method_name.to_s.start_with? 'test_'
    end

    def all_test_method_names clazz
      clazz.public_instance_methods.find_all do |m|
        test_method? m
      end
    end

    def replace_method clazz, new_method
      clazz.class_eval new_method
    end

    def save_meta_info clazz, method_name, metainfo
      clazz.meta_def method_name do
        metainfo
      end
    end
  end
end