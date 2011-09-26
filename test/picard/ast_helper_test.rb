require File.expand_path("../../test_helper", __FILE__)

class Picard::AstHelperTest < Test::Unit::TestCase
  include Picard::TestUnit
  include Picard::SExpressionSugar

  def setup
    formatter = Picard::SimpleErrorMessageFormatter.new
    wrapper = Picard::AssertionWrapper.new(formatter)
    @helper = Picard::AstHelper.new wrapper
  end


  class TestClass1
    def test_method
      one
      two
    end
  end

  def test_should_return_all_statements_of_method
    given
      method = TestClass1.instance_method(:test_method)
      actual = @helper.all_statements(method)

    expect
      actual[0].index == 0
      actual[0].ast == s(:call, nil, :one, s(:arglist))

      actual[1].index == 1
      actual[1].ast == s(:call, nil, :two, s(:arglist))
  end


  class TestClass2
    def test_method
      one
      expect
      two
    end
  end

  def test_should_find_all_statements_in_specified_block
    given
      method = TestClass2.instance_method(:test_method)
      all_statements = @helper.all_statements(method)
      actual = @helper.find_all_statements_in_block(all_statements, :expect)

    expect
      actual.size == 1
      actual[0].index == 2
      actual[0].ast == s(:call, nil, :two, s(:arglist))
  end


  class TestClass3
    def test_method
      one
      two
    end
  end

  def test_should_return_empty_array_if_specified_method_call_was_not_found
    given
      method = TestClass3.instance_method(:test_method)
      all_statements = @helper.all_statements(method)

    expect
      @helper.find_all_statements_in_block(all_statements, :expect) == []
  end


  class TestClass4
    def test_method
      false
    end
  end

  def test_should_replace_statement
    given
      method = TestClass4.instance_method(:test_method)
      @helper.replace_statement(method, 0, s(:lit, true))
      all_statements = @helper.all_statements(method)

    expect
      all_statements[0].ast == s(:lit, true)
  end


  def test_should_wrap_assertion
    given
      result = @helper.wrap_assertion(s(:lit, true))

    expect
      result == s(:call, nil, :assert, s(:arglist, s(:lit, true), s(:call, nil, :picard_format_error_message, s(:arglist, s(:str, 'true'), s(:lit, nil)))))
  end
end