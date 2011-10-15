require 'live_ast'

module Picard
  class MethodRipper
    def initialize ast_helper = AstHelper.new
      @ast_helper = ast_helper
    end

    def wrap_all_assertions! method
      ast = @ast_helper.extract_ast(method)
      assertions = ast.all_statements_in_block(:expect)

      replace_all_statements_with_assertions! ast, assertions, method
      replace_method_implementation_in_owner! ast, method
    end

    private

    def replace_all_statements_with_assertions! ast, assertions, method
      assertions.each do |e|
        wrapped = @ast_helper.wrap_assertion(method, e.ast)
        ast.replace_statement!(e.index, wrapped)
      end
    end

    def replace_method_implementation_in_owner! ast, method
      new_method_str = ast.generate_method
      method.owner.class_eval new_method_str
    end
  end
end