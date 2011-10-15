require File.expand_path("../../test_helper", __FILE__)

class Picard::MethodRipperTest < Test::Unit::TestCase
  include PicardStable::TestUnit
  
  class TestClass
    attr_reader :assert_args
    
    def test_method
      expect
      false
    end

    def regular_method
      false
    end

    def expect; end

    def assert arg
      @assert_args ||= []
      @assert_args << arg
    end
  end

  def setup
    wrapper = Picard::SimpleAssertionWrapper.new
    helper = Picard::AstHelper.new(wrapper)
    @ripper = Picard::MethodRipper.new(helper)
  end

  def test_should_wrap_all_assertions_after_expect_method_call
    given
      method = TestClass.instance_method(:test_method)
      @ripper.wrap_all_assertions!(method)
      tc = TestClass.new
      tc.test_method

    expect
      tc.assert_args == [false]
  end

  def test_should_not_change_method_if_no_expect_block
    given
      method = TestClass.instance_method(:regular_method)
      @ripper.wrap_all_assertions! method

    expect
      TestClass.new.regular_method == false
  end
end