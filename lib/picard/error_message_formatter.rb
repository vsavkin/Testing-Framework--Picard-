module Picard
  class ErrorMessageFormatter
     def format_message message, context
      location = "File: #{context.file}, Line: #{context.lineno}"
      new_message = "Failed Assertion: #{message}"

      lines = make_same_size(location, new_message)
      border = '-' * (lines.first.length + 2)
      "#{border}\n|#{lines[0]}|\n|#{lines[1]}|\n#{border}"
    end

    private
    def make_same_size a, b
      return make_same_size(b, a) if a.length < b.length
      if a.length > b.length
        [a, b + ' ' * (a.length - b.length)]
      else
        [a + ' ' * (b.length - a.length), b]
      end
    end
  end

  class SimpleErrorMessageFormatter
    def format_message message, context
      message
    end
  end
end