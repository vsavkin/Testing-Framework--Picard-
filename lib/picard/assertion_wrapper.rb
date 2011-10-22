require 'live_ast'
require 'ruby2ruby'
require_relative 's_expression_sugar'

module Picard

  class BasicAssertion
    def extract_argument ast
      ast[3][1]
    end

    def extract_receiver ast
      ast[1]
    end
  end

  class Default < BasicAssertion
    def === ast
      true
    end

    def transform ast, message
      s(:call, nil, :assert, s(:arglist,ast, s(:str, message)))
    end
  end

  class EqualTo < BasicAssertion
    def === ast
      ast[0] == :call and ast[2] == :==
    end

    def transform ast, message
      s(:call, nil,
          :assert_equal,
            s(:arglist,
              extract_argument(ast),
              extract_receiver(ast),
              s(:str, message)))
    end
  end

  class NotEqualTo < BasicAssertion
    def === ast
      ast[0] == :call and ast[2] == :'!='
    end

    def transform ast, message
      s(:call, nil,
          :assert_not_equal,
            s(:arglist,
              extract_argument(ast),
              extract_receiver(ast),
              s(:str, message)))
    end
  end

  class Match < BasicAssertion
    def === ast
      ast[0] == :call and ast[2] == :'=~'
    end

    def transform ast, message
      s(:call, nil,
          :assert_match,
            s(:arglist,
              extract_argument(ast),
              extract_receiver(ast),
              s(:str, message)))
    end
  end

  class AssertionWrapper
    include Picard::SExpressionSugar

    def initialize formatter = ErrorMessageFormatter.new
      @formatter = formatter
      @handlers = [EqualTo.new, NotEqualTo.new, Match.new, Default.new]
    end

    def wrap_assertion ast, context
      line = ast_to_str(ast)
      message = @formatter.format_message(line, context)

      handler = find_matching_handler ast
      handler.transform ast, message
    end

    private

    def find_matching_handler ast
      @handlers.find do |h|
        h === ast
      end
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