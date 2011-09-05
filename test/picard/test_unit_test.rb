require_relative '../test_helper'

class Picard::TestUnitTest < Test::Unit::TestCase
  include Picard::TestUnit
  
  class TestUsingPicard
    include Picard::TestUnit
    attr_reader :assert_args

    def test_method
      given
      x = 1

      expect
      x == 2
    end

    def assert arg
      @assert_args ||= []
      @assert_args << arg
    end
  end

  def test_should_add_assertions_to_all_test_methods
    given
      test = TestUsingPicard.new
      test.test_method

    expect
      test.assert_args == [false]
  end
end