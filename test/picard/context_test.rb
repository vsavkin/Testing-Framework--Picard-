require File.expand_path("../../test_helper", __FILE__)

class Picard::ContextTest < Test::Unit::TestCase
  include Picard::TestUnit

  def test_should_extract_filename_from_caller
    given
      caller = ["/path/to_file1:99:in 'method_name1'", "/path/to_file2:99:in 'method_name2'"]
      c = Context.new(caller)

    expect
      c.file == '/path/to_file1'
  end

  def test_should_ignore_invalid_input
    given
      c = Context.new []

    expect
      c.file == ""
  end

  def test_should_have_file_and_lineno_properties
    given
      c = Context.new []
      c.file = 'file'
      c.lineno = 10

    expect
      c.file == 'file'
      c.lineno == 10
  end
end