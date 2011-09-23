require 'live_ast'
require 'ruby2ruby'
require_relative 's_expression_sugar'

module Picard
  class AssertionWrapper
    include Picard::SExpressionSugar

    def wrap_assertion ast
      line = ast_to_str(ast)
      lineno = ast.line
      
      if equal_to_assertion? ast
        s(:call, nil,
                 :assert_equal,
                 s(:arglist,
                    extract_argument(ast),
                    extract_receiver(ast),
                    s(:call, nil, :picard_format_error_message, s(:arglist, s(:str, line), s(:lit, lineno)))))
      else
        s(:call, nil,
                 :assert,
                 s(:arglist,
                    ast,
                    s(:call, nil, :picard_format_error_message, s(:arglist, s(:str, line), s(:lit, lineno)))))
      end
    end

    private

    def equal_to_assertion? ast
      ast[0] == :call and ast[2] == :==
    end

    def extract_argument ast
      ast[3][1]
    end

    def extract_receiver ast
      ast[1]
    end

    def ast_to_str ast
      copy = Sexp.from_array(ast.to_a)
      Ruby2Ruby.new.process copy
    end
  end
end