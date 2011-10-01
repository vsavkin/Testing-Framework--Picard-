require 'live_ast'
require 'ruby2ruby'
require_relative 's_expression_sugar'

module Picard
  class AssertionWrapper
    include Picard::SExpressionSugar

    def initialize formatter = ErrorMessageFormatter.new
      @formatter = formatter
    end

    def wrap_assertion ast, context
      line = ast_to_str(ast)
      message = @formatter.format_message(line, context)
      
      if equal_to_assertion? ast
        s(:call, nil,
                 :assert_equal,
                 s(:arglist,
                    extract_argument(ast),
                    extract_receiver(ast),
                    s(:str, message)))
      else
        s(:call, nil, :assert, s(:arglist,ast, s(:str, message)))
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

  class SimpleAssertionWrapper
    include Picard::SExpressionSugar

    def wrap_assertion ast, context
      s(:call, nil,:assert,s(:arglist,ast))
    end
  end
end