require File.expand_path("../../test_helper", __FILE__)

class Picard::AstHelperTest < Test::Unit::TestCase
  include PicardStable::TestUnit
  include PicardStable::SExpressionSugar

  class TestClass1
    def test_method
    end
  end

  def test_ast_helper_should_add_nil_to_empty_method
    given
      ast = ast_of(TestClass1)

    expect
      ast.body_statements[0].ast == s(:nil)
  end


  class TestClass2
    def test_method
      one
      two
    end
  end

  def test_ast_helper_should_extract_ast_including_body_statments
    given
      statements = ast_of(TestClass2).body_statements

    expect
      statements[0].index == 1
      statements[0].ast == s(:call, nil, :one, s(:arglist))

      statements[1].index == 2
      statements[1].ast == s(:call, nil, :two, s(:arglist))
  end


  class TestClass3
    def test_method
      one
      expect
      two
    end
  end

  def test_method_ast_should_return_all_statements_in_block
    given
      statements = ast_of(TestClass3).all_statements_in_block(:expect)

    expect
      statements[0].index == 3
      statements[0].ast = s(:call, nil, :two, s(:arglist))
  end


  class TestClass4
    def test_method
      one
      two
    end
  end

  def test_method_ast_should_return_empty_array_if_block_is_not_found
    given
      statements = ast_of(TestClass4)

    expect
      statements.all_statements_in_block(:where) == []
  end


  class TestClass5
    def test_method
      false
    end
  end

  def test_method_ast_should_replace_statement
    given
      ast = ast_of(TestClass5)
      ast.replace_statement!(1, s(:true))

    expect
      ast.body_statements[0].ast == s(:true)
  end


  class TestClass6
    def test_method
      false
    end
  end

  def test_method_ast_should_generate_method_as_string
    given
      ast = ast_of(TestClass5)

    expect
      ast.generate_method == "def test_method\nfalse\nend"
  end


  def test_ast_helper_should_wrap_assertion
    given
      ast = flexmock(:line => 100)
      method = flexmock(:source_location => ['location'])
      expected_context = Picard::Context.new('location', 100)
    
      wrapper = flexmock('wrapper')
      wrapper.should_receive(:wrap_assertion).with(ast, expected_context).and_return('wrapped ast')

      helper = Picard::AstHelper.new(wrapper)
    
    expect
      helper.wrap_assertion(method, ast) == 'wrapped ast'
  end

  private

  def ast_of(clazz)
    method = clazz.instance_method(:test_method)
    Picard::AstHelper.new.extract_ast(method)
  end
end