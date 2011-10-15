require File.expand_path("../../test_helper", __FILE__)
#require 'live_ast'
#require 'live_ast_ripper'
#require 'sorcerer'
#require 'test/unit'
#require 'sourcify'
#require 'ruby2ruby'


module Picard
  class DemoTest < Test::Unit::TestCase
    include Picard::TestUnit
    #
    #def test_one
    #  expect
    #    2 == 2
    #end

    #def method1
    #  false
    #end

    #def test_what_breaks_ruby
    #  #method = MyMath.method(:regular_method)
    #  #puts method.inspect
    #  #puts method.to_sexp.inspect
    #  method = DemoTest.instance_method(:method1)
    #  #method = method.bind('fake')
    #  puts method.inspect
    #
    #  ast = method.to_sexp do |code|
    #    index = code.index('def') + 3
    #    code[index...index] = ' fake.'
    #    true
    #  end
    #  puts ast.inspect
    #  puts Ruby2Ruby.new.process(ast)
    #  #puts(ast.inspect)
    #end

    #
    #def test_two
    #  ast = DemoTest.instance_method(:regular_method).to_ast
    #  puts ast.class.name
    #end
  end
end