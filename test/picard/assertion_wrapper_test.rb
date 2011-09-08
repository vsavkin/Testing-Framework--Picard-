require File.expand_path("../../test_helper", __FILE__)

class Picard::AssertionWrapperTest < Test::Unit::TestCase
  include Picard::TestUnit
  include Picard::SExpressionSugar

  def setup
    formatter = Picard::SimpleErrorMessageFormatter.new
    @wrapper = Picard::AssertionWrapper.new(formatter)
  end

  def test_should_wrap_simple_assertions
    given
      result = @wrapper.wrap_assertion(s(:lit, true))

    expect
      result == s(:call, nil, :assert, s(:arglist, s(:lit, true), s(:str, 'true')))
  end

  def test_should_wrap_equal_to_assertions
    given
      result = @wrapper.wrap_assertion(s(:call, s(:lit, 1), :==, s(:arglist, s(:lit, 2))))

    expect
      result == s(:call, nil, :assert_equal, s(:arglist, s(:lit, 2), s(:lit, 1), s(:str, '(1 == 2)')))
  end

  def another
    assert_equal 2, 1, 'Message'
  end
end