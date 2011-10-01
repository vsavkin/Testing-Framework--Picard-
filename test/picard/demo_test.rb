require File.expand_path("../../test_helper", __FILE__)
require 'live_ast'

module Picard
  class DemoTest < Test::Unit::TestCase
    include Picard::TestUnit

    #def test_one
    #  expect
    #    1 == 2
    #end
    #def regular_method
    #  method 1, 2
    #end
    #
    #def test_two
    #  ast = DemoTest.instance_method(:regular_method).to_ast
    #  puts ast.class.name
    #end
  end
end