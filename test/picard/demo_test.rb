require File.expand_path("../../test_helper", __FILE__)

module Picard
  class DemoTest < Test::Unit::TestCase
    include Picard::TestUnit

    def test_should_work_with_assert_equals
      given
        x = 1

      expect
        x == 2
    end
  end
end