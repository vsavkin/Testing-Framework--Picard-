require File.expand_path("../../test_helper", __FILE__)

class Picard::PreprocessorTest < Test::Unit::TestCase
  include Picard::TestUnit
  include RR::Adapters::RRMethods

  class BaseTestClass
    attr_reader :assert_args

    def given; end
    def expect; end
    def where; end
    def picard_format_error_message(m); end


    def assert arg, message
      @assert_args ||= []
      @assert_args << arg
    end
  end

  def setup
    @pr = Picard::Preprocessor.new
  end

  # We need to use a class per test for test isolation
  class TestClass < BaseTestClass
    def test_method
      expect
      false
    end
  end

  def test_should_wrap_all_assertions_after_expect_in_all_test_methods
    given
      @pr.preprocess_class(TestClass)
      tc = TestClass.new
      tc.test_method

    expect
      tc.assert_args == [false]
  end


  class TestClass2 < BaseTestClass
    def test_method
      expect
      false
    end
  end

  def test_should_wrap_all_assertions_in_specified_method
    given
      @pr.preprocess_method(TestClass2, :test_method)
      tc = TestClass2.new
      tc.test_method

    expect
      tc.assert_args == [false]
  end

  
  class TestClass3 < BaseTestClass
    def test_method
      expect
      false
    end
  end

  def test_should_not_preprocess_the_same_method_twice
    given
      @pr.preprocess_method(TestClass3, :test_method)
      @pr.preprocess_method(TestClass3, :test_method)

      tc = TestClass3.new
      tc.test_method

    expect
      tc.assert_args == [false]
  end


  class TestClass4 < BaseTestClass
    def regular_method
      false
    end
  end

  def test_should_ignore_non_test_methods
    given
      @pr.preprocess_method(TestClass4, :regular_method)
      tc = TestClass4.new
      tc.regular_method

    expect
      tc.assert_args == nil
  end


  class TestClass5 < BaseTestClass
  end

  def test_should_generate_method_returning_context
    given
      context = Struct.new(:file).new('file')
      @pr.generate_context_method(TestClass5, context)

    expect
      TestClass5.picard_meta_info.file == 'file'
  end


  class TestClass6 < BaseTestClass
    def test_empty
    end
  end

  def test_should_successfully_transform_empty_methods
    given
      @pr.preprocess_method(TestClass6, :test_empty)
      tc = TestClass6.new
      tc.test_empty

    expect
      tc.assert_args == nil
  end


  class TestClass7 < BaseTestClass
    def test_empty
      expect
    end
  end

  def test_should_successfully_transform_methods_with_empty_expect_block
    given
      @pr.preprocess_method(TestClass7, :test_empty)
      tc = TestClass7.new
      tc.test_empty

    expect
      tc.assert_args == nil
  end
end