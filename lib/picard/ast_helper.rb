require 'live_ast'
require 'ruby2ruby'

module Picard
  class AstHelper
    ResultItem = Struct.new(:index, :ast)

    def initialize wrapper = Picard::AssertionWrapper.new
      @wrapper = wrapper
    end

    def all_statements method
      method_ast = method.to_ast
      body_statements = extract_body_statements(method_ast)
      wrap_in_result_items body_statements
    end

    def find_all_statements_in_block statements, block_name
      start_index = find_index_of_statements_calling(statements, block_name)
      end_index = find_index_of_statements_calling(statements, :where)
      end_index = end_index ? end_index - 1 : -1
      start_index ? statements[start_index + 1 .. end_index] : []
    end

    def wrap_assertion ast
      @wrapper.wrap_assertion ast
    end

    def replace_statement method, index, new_ast
      method_ast = method.to_ast
      body_statements = extract_statements(method_ast)
      body_statements[index + 1] = new_ast
    end

    def extract_ast method
      method.to_ast
    end

    def ast_to_str ast
      Ruby2Ruby.new.process ast
    end

    private

    def find_index_of_statements_calling items, method_name
      items.index do |item|
        ast = item.ast
        ast[0] == :call and ast[2] == method_name
      end
    end

    def extract_body_statements method_ast
      st = extract_statements(method_ast)
      remove_prefix_statement st
    end

    def remove_prefix_statement statements
      statements[1..-1]
    end

    def extract_statements method_ast
      method_ast[3][1]
    end

    def wrap_in_result_items asts
      res = []
      asts.each_with_index do |e, i|
        res << ResultItem.new(i, e)
      end
      res
    end
  end
end