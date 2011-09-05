require_relative '../test_helper'

class Picard::AstHelperTest < Test::Unit::TestCase
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
    @helper = Picard::AstHelper.new
  end

  def test_should_return_all_statements_of_method
    method = TestClass.instance_method(:test_method)
    actual = @helper.all_statements(method)
    
    assert_equal 0, actual[0].index
    assert_equal s(:lasgn, :x, s(:lit, 10)), actual[0].ast

    assert_equal 1, actual[1].index
    assert_equal s(:call, nil, :expect, s(:arglist)), actual[1].ast

    assert_equal 2, actual[2].index
    assert_equal s(:call, s(:lvar, :x), :==, s(:arglist, s(:lit, 10))), actual[2].ast

    assert_equal 3, actual[3].index
    assert_equal s(:call, s(:lvar, :x), :==, s(:arglist, s(:lit, 12))), actual[3].ast
  end

  def test_should_find_all_statements_in_specified_block
    method = TestClass.instance_method(:test_method)
    all_statements = @helper.all_statements(method)
    actual = @helper.find_all_statements_in_block(all_statements, :expect)

    assert_equal 2, actual.size

    assert_equal 2, actual[0].index
    assert_equal s(:call, s(:lvar, :x), :==, s(:arglist, s(:lit, 10))), actual[0].ast

    assert_equal 3, actual[1].index
    assert_equal s(:call, s(:lvar, :x), :==, s(:arglist, s(:lit, 12))), actual[1].ast
  end

  def test_should_return_empty_array_if_specified_method_call_was_not_found
    method = TestClass.instance_method(:method_without_assertions)
    all_statements = @helper.all_statements(method)
    actual = @helper.find_all_statements_in_block(all_statements, :expect)
    assert_equal [], actual
  end

  def test_should_wrap_assertion
    result = @helper.wrap_assertion(s(:lit, true))
    assert_equal s(:call, nil, :assert, s(:arglist, s(:lit, true))), result
  end

  def test_should_replace_statement
    method = TestClass.instance_method(:test_method_to_replace_statements)
    @helper.replace_statement(method, 0, s(:lit, true))
    
    all_statements = @helper.all_statements(method)
    assert_equal s(:lit, true), all_statements[0].ast
  end

  def test_should_return_list_of_all_local_variables_defined_after_specified_method_call
    method = TestClass.instance_method(:test_method_with_where_block)
    all_statements = @helper.all_statements(method)
    actual = @helper.find_all_local_variables_in_block(all_statements, :where)
    assert_equal [:y, :z], actual
  end

  private
  def s(*args)
    Sexp.new *args
  end
end