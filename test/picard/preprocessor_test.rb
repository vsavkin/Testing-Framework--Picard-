require_relative '../test_helper'

class Picard::PreprocessorTest < Test::Unit::TestCase
  include Picard::TestUnit
  include RR::Adapters::RRMethods

  class BaseTestClass
    attr_reader :assert_args

    def initialize
      @assert_args = []
    end

    def given
    end

    def expect
    end

    def where
    end

    def assert arg
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
      1 == 2
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
      1 == 2
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
      1 == 2
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
      1 == 2
    end
  end

  def test_should_ignore_non_test_methods
    given
      @pr.preprocess_method(TestClass4, :regular_method)
      tc = TestClass4.new
      tc.regular_method

    expect
      tc.assert_args == []
  end


  #class TestClass5 < BaseTestClass
  #  def test_method
  #    expect
  #    x == 1
  #
  #    where
  #    x = 2
  #  end
  #end
  #
  #def test_should_use_local_variables_from_where_block
  #  tr = Picard::Preprocessor.new ClassRipper.new,
  #  tr.preprocess_method(TestClass5, :test_method)
  #
  #  tc = TestClass5.new
  #  tc.test_method
  #  assert_equal [false], tc.assert_args
  #end
end