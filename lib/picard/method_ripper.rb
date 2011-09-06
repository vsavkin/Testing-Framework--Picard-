require 'live_ast'
require 'live_ast/to_ruby'

module Picard
  class MethodRipper
    def initialize ast_helper = AstHelper.new
      @ast_helper = ast_helper
    end

    def wrap_all_assertions method
      all_statements = @ast_helper.all_statements(method)
      assertions = @ast_helper.find_all_statements_in_block(all_statements, :expect)
      replace_all_statements_with_assertions assertions, method
      ast_to_str @ast_helper.extract_ast(method)
    end

    private

    def replace_all_statements_with_assertions assertions, method
      assertions.each do |e|
        wrapped = @ast_helper.wrap_assertion(e.ast)
        @ast_helper.replace_statement(method, e.index, wrapped)
      end
    end

    def ast_to_str ast
      remove_spaces @ast_helper.ast_to_str(ast)
    end

    def remove_spaces str
      str.gsub(/\n\s+/, "\n")
    end
  end
end