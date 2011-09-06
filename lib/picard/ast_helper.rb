require 'live_ast'
require 'ruby2ruby'

module Picard
  class AstHelper
    ResultItem = Struct.new(:index, :ast)

    def all_statements method
      method_ast = method.to_ast
      body_statements = extract_statements(method_ast)[1..-1]
      wrap_in_result_items body_statements
    end

    def find_all_statements_in_block items, block_name
      start_index = find_index_of_statements_calling(items, block_name)
      end_index = find_index_of_statements_calling(items, :where)
      end_index = end_index ? end_index - 1 : -1
      start_index ? items[start_index + 1 .. end_index] : []
    end

    def wrap_assertion ast
      copy = Sexp.from_array(ast.to_a)
      error_message = 'Failed: ' + Ruby2Ruby.new.process(copy)
      Sexp.new(:call, nil,
               :assert,
               Sexp.new(:arglist, ast),
               Sexp.new(:str, error_message))
    end

    def replace_statement method, index, new_ast
      method_ast = method.to_ast
      body_statements = extract_statements(method_ast)
      body_statements[index + 1] = new_ast
    end

    def extract_ast method
      method.to_ast
    end

    def find_all_local_variables_in_block items, block_name
      index = find_index_of_statements_calling(items, block_name)
      return [] unless index
      items[index + 1 .. -1].find_all do |e|
        e.ast[0] == :lasgn
      end.collect do |e|
        e.ast[1]
      end
    end

    private
    def find_index_of_statements_calling(items, method_name)
      items.index do |item|
        ast = item.ast
        ast[0] == :call and ast[2] == method_name
      end
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