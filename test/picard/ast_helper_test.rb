require File.expand_path("../../test_helper", __FILE__)

class Picard::AstHelperTest < Test::Unit::TestCase
  include Picard::TestUnit
  include Picard::SExpressionSugar

  class TestClass
    def test_method
      x = 10

      expect
      x == 10
      x == 12

      where
      y = 1
    end

    def method_without_assertions
      'dummy'
    end

    def test_method_to_replace_statements
      'dummy'
    end

    def test_method_with_where_block
      x = 10

      where
      y = 20
      z = 30
    end
  end

  def setup
    formatter = Picard::SimpleErrorMessageFormatter.new
    wrapper = Picard::AssertionWrapper.new(formatter)
    @helper = Picard::AstHelper.new wrapper
  end

  def test_should_return_all_statements_of_method
    given
      method = TestClass.instance_method(:test_method)
      actual = @helper.all_statements(method)

    expect
      actual[0].index == 0
      actual[0].ast == s(:lasgn, :x, s(:lit, 10))

      actual[1].index == 1
      s(:call, nil, :expect, s(:arglist)) == actual[1].ast

      actual[2].index == 2
      actual[2].ast == s(:call, s(:lvar, :x), :==, s(:arglist, s(:lit, 10)))

      actual[3].index == 3
      actual[3].ast == s(:call, s(:lvar, :x), :==, s(:arglist, s(:lit, 12)))
  end

  def test_should_find_all_statements_in_specified_block
    given
      method = TestClass.instance_method(:test_method)
      all_statements = @helper.all_statements(method)
      actual = @helper.find_all_statements_in_block(all_statements, :expect)

    expect
      actual.size == 2

      actual[0].index == 2
      actual[0].ast == s(:call, s(:lvar, :x), :==, s(:arglist, s(:lit, 10)))

      actual[1].index == 3
      actual[1].ast == s(:call, s(:lvar, :x), :==, s(:arglist, s(:lit, 12)))
  end

  def test_should_return_empty_array_if_specified_method_call_was_not_found
    given
      method = TestClass.instance_method(:method_without_assertions)
      all_statements = @helper.all_statements(method)

    expect
      @helper.find_all_statements_in_block(all_statements, :expect) == []
  end

  def test_should_replace_statement
    given
      method = TestClass.instance_method(:test_method_to_replace_statements)
      @helper.replace_statement(method, 0, s(:lit, true))
      all_statements = @helper.all_statements(method)

    expect
      all_statements[0].ast == s(:lit, true)
  end

  def test_should_return_list_of_all_local_variables_defined_after_specified_method_call
    given
      method = TestClass.instance_method(:test_method_with_where_block)
      all_statements = @helper.all_statements(method)

    expect
      @helper.find_all_local_variables_in_block(all_statements, :where) == [:y, :z]
  end

  def test_should_wrap_assertion
    given
      result = @helper.wrap_assertion(s(:lit, true))

    expect
      result == s(:call, nil, :assert, s(:arglist, s(:lit, true), s(:call, nil, :picard_format_error_message, s(:arglist, s(:str, 'true')))))
  end
end