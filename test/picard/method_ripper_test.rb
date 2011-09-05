require_relative '../test_helper'

class Picard::MethodRipperTest < Test::Unit::TestCase
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
    method = TestClass.instance_method(:test_method)
    new_method_str = @ripper.wrap_all_assertions(method)
    assert_equal "def test_method\ngiven\nsomething\nexpect\nassert((1 == 1))\nassert((2 == 2))\nend", new_method_str
  end

  def test_should_return_existing_implementation_if_there_was_no_expect_method_call
    method = TestClass.instance_method(:regular_method)
    new_method_str = @ripper.wrap_all_assertions(method)
    assert_equal "def regular_method\n(1 == 1)\n(2 == 2)\nend", new_method_str
  end
end