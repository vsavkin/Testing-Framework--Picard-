require_relative '../test_helper'

class Picard::ClassRipperTest < Test::Unit::TestCase
  include Picard::TestUnit
  
  class TestClass
    def test_one; end
    def test_two; end
    def three; end
  end

  class TestClassWithoutTestMethods
    def method1; end
  end

  class DummyClass
    def dummy
      'dummy'
    end
  end

  def setup
    @ripper = Picard::ClassRipper.new
  end

  def test_should_return_if_method_is_test_method
    expect
      @ripper.test_method?('test_method')
      !@ripper.test_method?('regular_method')
  end

  def test_should_return_list_of_all_test_methods
    expect
      @ripper.all_test_method_names(TestClass) == [:test_one, :test_two]
  end

  def test_should_return_empty_list_if_there_are_no_test_methods
    expect
      @ripper.all_test_method_names(TestClassWithoutTestMethods) == []
  end

  def test_should_replace_method_implementation
    given
      @ripper.replace_method(DummyClass, "def dummy\n 'replaced' \n end")

    expect
      DummyClass.new.dummy == 'replaced'
  end
end

