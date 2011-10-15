require File.expand_path("../../test_helper", __FILE__)

class Picard::ClassRipperTest < Test::Unit::TestCase
  include PicardStable::TestUnit

  def setup
    @ripper = Picard::ClassRipper.new
  end
  

  def test_should_tell_if_method_name_is_test_method_name
    expect
      @ripper.test_method?('test_method')
      !@ripper.test_method?('regular_method')
  end

  
  class TestClass1
    def test_one; end
    def test_two; end
    def three; end
  end

  def test_should_return_list_of_all_test_methods
    expect
      @ripper.all_test_method_names(TestClass1) == [:test_one, :test_two]
  end


  class TestClass2
    def method1; end
  end

  def test_should_return_empty_list_if_there_are_no_test_methods
    expect
      @ripper.all_test_method_names(TestClass2) == []
  end
end

