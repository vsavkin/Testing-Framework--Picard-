require File.expand_path("../../test_helper", __FILE__)

class Picard::ContextTest < Test::Unit::TestCase
  include Picard::TestUnit

  def setup
    @context = Picard::Context.new
  end

  def test_should_return_file_name_of_callee
    expect
      return_callee_file(@context) == 'context_test.rb'
  end

  def test_should_return_lineno
    expect
      return_callee_lineno(@context) == 17
  end

  private
  def return_callee_file context
    context.file
  end

  def return_callee_lineno context
    context.lineno
  end
end