require 'live_ast'

module Picard
  class MethodRipper
    def initialize ast_helper = AstHelper.new
      @ast_helper = ast_helper
    end

    def wrap_all_assertions! method
      assertions = @ast_helper.all_statements_in_block(method, :expect)
      replace_all_statements_with_assertions! assertions, method
      replace_method_implementation_in_owner! method
    end

    private

    def replace_all_statements_with_assertions! assertions, method
      assertions.each do |e|
        wrapped = @ast_helper.wrap_assertion(method, e.ast)
        @ast_helper.replace_statement(method, e.index, wrapped)
      end
    end

    def replace_method_implementation_in_owner! method
      new_method_str = @ast_helper.method_to_string(method)
      method.owner.class_eval new_method_str
    end
  end
end