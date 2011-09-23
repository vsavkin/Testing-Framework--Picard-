require File.expand_path("../../test_helper", __FILE__)

class Picard::TestUnitTest < Test::Unit::TestCase
  include Picard::TestUnit
  
  class TestUsingPicard
    include Picard::TestUnit
    attr_reader :assert_args

    def test_method
      expect
      false
    end

    def assert arg, message
      @assert_args ||= []
      @assert_messages ||= []
      @assert_args << arg
      @assert_messages << message
    end
  end

  def test_should_add_assertions_to_all_test_methods
    given
      test = TestUsingPicard.new
      test.test_method

    expect
      test.assert_args == [false]
  end

  def test_should_add_meta_information_to_class
    expect
      TestUsingPicard.picard_meta_info.file =~ /test_unit_test.rb/
  end
end