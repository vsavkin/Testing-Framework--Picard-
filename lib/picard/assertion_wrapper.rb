require 'live_ast'
require 'ruby2ruby'
require_relative 's_expression_sugar'

module Picard
  class AssertionWrapper
    include Picard::SExpressionSugar

    def initialize formatter = Picard::ErrorMessageFormatter.new
      @formatter = formatter
    end

    def wrap_assertion ast
      error_message = generate_error_message(ast)
      if equal_to_assertion? ast
        s(:call, nil,
                 :assert_equal,
                 s(:arglist,
                    extract_argument(ast),
                    extract_receiver(ast),
                    s(:str, error_message)))
      else
        s(:call, nil,
                 :assert,
                 s(:arglist,
                    ast,
                    s(:str, error_message)))
      end
    end

    def generate_error_message ast
      copy = Sexp.from_array(ast.to_a)
      @formatter.format_message ast_to_str(copy), :file => 'file', :lineno => ast.line
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
      Ruby2Ruby.new.process ast
    end
  end
end