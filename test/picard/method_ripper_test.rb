require File.expand_path("../../test_helper", __FILE__)

class Picard::MethodRipperTest < Test::Unit::TestCase
  include Picard::TestUnit
  
  class TestClass
    def test_method
      given
      something
      expect
      1 == 1
      2 == 2
    end

    def regular_method
      1 == 1
      2 == 2
    end
  end

  def setup
    @ripper = Picard::MethodRipper.new
  end

  def test_should_wrap_all_assertions_after_expect_method_call
    given
      method = TestClass.instance_method(:test_method)
      expected_after_processing = "def test_method\ngiven\nsomething\nexpect\nassert((1 == 1), \"Failed: (1 == 1)\")\nassert((2 == 2), \"Failed: (2 == 2)\")\nend"

    expect
      @ripper.wrap_all_assertions(method) == expected_after_processing
  end

  def test_should_return_existing_implementation_if_there_was_no_expect_method_call
    given
      method = TestClass.instance_method(:regular_method)
      expected_after_processing = "def regular_method\n(1 == 1)\n(2 == 2)\nend"

    expect
      @ripper.wrap_all_assertions(method) == expected_after_processing
  end
end