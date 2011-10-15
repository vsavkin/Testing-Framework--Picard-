require 'ruby2ruby'

module Picard

  ResultItem = Struct.new(:ast, :index)

  class AstHelper
    def initialize(wrapper = Picard::AssertionWrapper.new)
      @wrapper = wrapper
    end

    def extract_ast method
      ast = method.to_sexp do |code|
        index = code.index('def') + 3
        code[index...index] = ' fake.'
        true
      end
      MethodAst.new ast
    end

    def wrap_assertion method, ast
      context = Picard::Context.new(method.source_location[0], ast.line)
      @wrapper.wrap_assertion ast, context
    end
  end
  
  class MethodAst
    def initialize ast
      @ast = ast
    end

    def body_statements
      st = wrap_into_result_items(all_statements)
      remove_prefix_statement st
    end

    def all_statements_in_block block_name
      statements = body_statements
      start_index = find_index_of_statements_calling(statements, block_name)
      start_index ? statements[start_index + 1 .. -1] : []
    end

    def replace_statement! index, new_statement
      all_statements[index] = new_statement
    end

    def generate_method
      str = ast_to_str(@ast)
      remove_spaces str
    end

  private

    def wrap_into_result_items statements
      res = []
      statements.each_with_index do |s, i|
        res << ResultItem.new(s, i)
      end
      res
    end

    def remove_prefix_statement statements
      statements[1..-1]
    end

    def all_statements
      @ast[3][1]
    end

    def find_index_of_statements_calling items, method_name
      items.index do |item|
        item.ast[0] == :call and item.ast[2] == method_name
      end
    end

    def ast_to_str ast
      Ruby2Ruby.new.process ast
    end

    def remove_spaces str
      str.gsub(/\n\s+/, "\n")
    end
  end
end