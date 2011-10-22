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
      context = init_context_and_formatter('true')

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
      context = init_context_and_formatter('(1 == 2)')

    expect
      @wrapper.wrap_assertion(ast, context) == s(:call, nil,
                  :assert_equal,
                  s(:arglist,
                    s(:lit, 2),
                    s(:lit, 1),
                    s(:str, 'generated error message')))
  end

  def test_should_wrap_not_equal_to_assertions
    given
      ast = s(:call, s(:lit, 1), :'!=', s(:arglist, s(:lit, 2)))
      context = init_context_and_formatter('1.!=(2)')

    expect
      @wrapper.wrap_assertion(ast, context) == s(:call, nil,
                  :assert_not_equal,
                  s(:arglist,
                    s(:lit, 2),
                    s(:lit, 1),
                    s(:str, 'generated error message')))
  end

  def test_should_wrap_matching_assertions
    given
      ast = s(:call, s(:lit, 1), :'=~', s(:arglist, s(:lit, 2)))
      context = init_context_and_formatter('1.=~(2)')

    expect
      @wrapper.wrap_assertion(ast, context) == s(:call, nil,
                  :assert_match,
                  s(:arglist,
                    s(:lit, 2),
                    s(:lit, 1),
                    s(:str, 'generated error message')))
  end

  private
  def init_context_and_formatter line
    context = flexmock(:file => 'file', :lineno => 1)
    @formatter.should_receive(:format_message).with(line, context).and_return('generated error message')
    context
  end
end