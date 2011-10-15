require File.expand_path("../../test_helper", __FILE__)

class Picard::ErrorMessageFormatterTest < Test::Unit::TestCase
  include PicardStable::TestUnit

  def test_should_wrap_error_message
    given
      formatter = Picard::ErrorMessageFormatter.new
      expected = <<str
-----------------------------
| Failed Assertion: message |
| File: file, Line: 1       |
-----------------------------
str

    expect
      formatter.format_message('message', create_context('file', 1)) == expected.chomp
  end

  private
  def create_context(filename, lineno)
    Struct.new(:file, :lineno).new(filename, lineno)
  end
end
