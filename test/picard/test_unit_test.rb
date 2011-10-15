require File.expand_path("../../test_helper", __FILE__)

class Picard::TestUnitTest < Test::Unit::TestCase
  include PicardStable::TestUnit

  class TestUsingPicard
    include Picard::TestUnit
    attr_reader :assert_arg, :assert_message

    def test_method
      expect
      false
    end

    def assert arg, message
      @assert_arg = arg
      @assert_message = message
    end
  end

  def test_should_add_assertions_to_all_test_methods
    given
      test = TestUsingPicard.new
      test.test_method

    expect
      test.assert_arg == false
  end

  def test_should_use_specific_messages
    given
      test = TestUsingPicard.new
      test.test_method

    expect
      test.assert_message.split("\n")[2] =~ /Failed Assertion: false/
      test.assert_message.split("\n")[1]  =~ /test_unit_test.rb/
      test.assert_message.split("\n")[1]  =~ /Line: 13/ #TODO fixit, it must be Line: 12
  end
end