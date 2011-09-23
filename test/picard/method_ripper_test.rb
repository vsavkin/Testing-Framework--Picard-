require File.expand_path("../../test_helper", __FILE__)

class Picard::MethodRipperTest < Test::Unit::TestCase
  include Picard::TestUnit
  
  class TestClass
    def test_method
      given
      something
      expect
      false
    end

    def regular_method
      false
    end
  end

  def setup
    formatter = Picard::SimpleErrorMessageFormatter.new
    wrapper = Picard::AssertionWrapper.new(formatter)
    helper = Picard::AstHelper.new(wrapper)
    @ripper = Picard::MethodRipper.new(helper)
  end

  def test_should_wrap_all_assertions_after_expect_method_call
    given
      method = TestClass.instance_method(:test_method)

      #it's a known defect. Line number needs to be 11. todo FIXIT
      expected_after_processing = "def test_method\ngiven\nsomething\nexpect\nassert(false, picard_format_error_message(\"false\", 12))\nend"

    expect
      @ripper.wrap_all_assertions(method) == expected_after_processing
  end

  def test_should_return_existing_implementation_if_there_was_no_expect_method_call
    given
      method = TestClass.instance_method(:regular_method)
      expected_after_processing = "def regular_method\nfalse\nend"

    expect
      @ripper.wrap_all_assertions(method) == expected_after_processing
  end
end