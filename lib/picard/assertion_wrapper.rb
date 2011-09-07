require 'live_ast'
require 'ruby2ruby'
require_relative 's_expression_sugar'

module Picard
  class AssertionWrapper
    include Picard::SExpressionSugar
    
    def wrap_assertion ast
      error_message = generate_error_message(ast)
      if ast[0] == :call and ast[2] == :==
        s(:call, nil,
                 :assert_equal,
                 s(:arglist, ast[3][1], ast[1], s(:str, error_message)))
      else
        s(:call, nil,
                 :assert,
                 s(:arglist, ast),
                 s(:str, error_message))
      end
    end

    private

    def generate_error_message ast
      copy = Sexp.from_array(ast.to_a)
      'Failed: ' + ast_to_str(copy)
    end

    def ast_to_str ast
      Ruby2Ruby.new.process ast
    end
  end
end