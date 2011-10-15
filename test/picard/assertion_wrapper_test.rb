require File.expand_path("../../test_helper", __FILE__)

class Picard::AssertionWrapperTest < Test::Unit::TestCase
  include PicardStable::TestUnit
  include PicardStable::SExpressionSugar

  def setup
    @formatter = flexmock('formatter')
    @wrapper = Picard::AssertionWrapper.new @formatter
  end

  def test_should_wrap_simple_assertions
    given
      ast = s(:lit, true)
      context = flexmock(:file => 'file', :lineno => 1)
      @formatter.should_receive(:format_message).with('true', context).and_return('generated error message')

    expect
      @wrapper.wrap_assertion(ast, context) == s(:call, nil,
                  :assert,
                  s(:arglist,
                    s(:lit, true),
                    s(:str, 'generated error message')))
  end

  def test_should_wrap_equal_to_assertions
    given
      ast = s(:call, s(:lit, 1), :==, s(:arglist, s(:lit, 2)))
      context = flexmock(:file => 'file', :lineno => 1)
      @formatter.should_receive(:format_message).with('(1 == 2)', context).and_return('generated error message')

    expect
      @wrapper.wrap_assertion(ast, context) == s(:call, nil,
                  :assert_equal,
                  s(:arglist,
                    s(:lit, 2),
                    s(:lit, 1),
                    s(:str, 'generated error message')))
  end
end