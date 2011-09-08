require File.expand_path("../../test_helper", __FILE__)

class Picard::ErrorMessageFormatterTest < Test::Unit::TestCase
  include Picard::TestUnit

  def test_should_wrap_error_message
    given
      formatter = Picard::ErrorMessageFormatter.new

    expect
      formatter.format_message('message') == "---------------------------\n|Failed Assertion: message|\n---------------------------"
  end
end
