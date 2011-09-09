require File.expand_path("../../test_helper", __FILE__)

class Picard::ErrorMessageFormatterTest < Test::Unit::TestCase
  include Picard::TestUnit

  def test_should_wrap_error_message
    given
      formatter = Picard::ErrorMessageFormatter.new
      expected = "---------------------------\n|Failed Assertion: message|\n|File: file, Line: 1      |\n---------------------------"

    expect
      formatter.format_message('message', create_context('file', 1)) == expected
  end

  private
  def create_context(filename, lineno)
    Struct.new(:file, :lineno).new(filename, lineno)
  end
end
