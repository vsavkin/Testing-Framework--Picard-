require_relative '../test_helper'

class Picard::ExpectBlockTest < Test::Unit::TestCase

  def test_should_call_passed_block
    res = nil
    Picard::ExpectBlock.invoke do
      res = true
    end
    assert res
  end

  def test_should_use_passed_variables_in_block
    res = nil
    Picard::ExpectBlock.invoke(true) do |x|
      res = x
    end
    assert res
  end
end