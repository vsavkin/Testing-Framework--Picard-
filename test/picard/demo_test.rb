require File.expand_path("../../test_helper", __FILE__)
require 'live_ast'

module Picard
  class DemoTest < Test::Unit::TestCase
    include Picard::TestUnit

    def test_should_work_with_assert_equals
      given
      x = 1

      expect
      x == 1
    end

    def regular_method
      puts 'ass'
    end

    #def test_me
    #  ast = Picard::DemoTest.instance_method(:regular_method).to_ast
    #  pp ast.line
    #  pp ast.inspect
    #end
  end
end