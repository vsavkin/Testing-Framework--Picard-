require File.expand_path("../../test_helper", __FILE__)

class Picard::AssertionWrapperTest < Test::Unit::TestCase
  include Picard::TestUnit
  include Picard::SExpressionSugar
  include RR::Adapters::RRMethods

  def setup
    @wrapper = Picard::AssertionWrapper.new
  end

  def test_should_wrap_simple_assertions
    given
      ast = s(:lit, true)
      result = wrap_assertion_on_line(ast, 99)

    expect
      result == s(:call, nil,
                  :assert,
                  s(:arglist,
                    s(:lit, true),
                    s(:call, nil, :picard_format_error_message, s(:arglist, s(:str, 'true'), s(:lit, 99)))))
  end

  def test_should_wrap_equal_to_assertions
    given
      ast = s(:call, s(:lit, 1), :==, s(:arglist, s(:lit, 2)))
      result = wrap_assertion_on_line(ast, 99)

    expect
      result == s(:call, nil,
                  :assert_equal,
                  s(:arglist,
                    s(:lit, 2),
                    s(:lit, 1),
                    s(:call, nil, :picard_format_error_message, s(:arglist, s(:str, '(1 == 2)'), s(:lit, 99)))))
  end
  
  private
  def wrap_assertion_on_line(ast, line)
    mock(ast).line{line}
    @wrapper.wrap_assertion(ast)
  end
end