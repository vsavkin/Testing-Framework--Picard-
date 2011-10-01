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

    def all_statements_in_block method, block_name
      statements = all_statements(method)

      start_index = find_index_of_statements_calling(statements, block_name)
      start_index ? statements[start_index + 1 .. -1] : []
    end

    def wrap_assertion method, ast
      context = Picard::Context.new(method.source_location, ast.line)
      @wrapper.wrap_assertion ast, context
    end

    def replace_statement method, index, new_statement_ast
      method_ast = method.to_ast
      body_statements = extract_statements(method_ast)
      body_statements[index + 1] = new_statement_ast
    end

    def method_to_string method
      ast = method.to_ast
      str = ast_to_str ast
      remove_spaces str
    end

    private

    def ast_to_str ast
      Ruby2Ruby.new.process ast
    end

    def remove_spaces str
      str.gsub(/\n\s+/, "\n")
    end

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