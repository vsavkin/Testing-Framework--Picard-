module Picard
  class ErrorMessageFormatter
    def format_message message
      new_message = "Failed Assertion: #{message}"
      line = '-' * (new_message.length + 2)
      "#{line}\n|#{new_message}|\n#{line}"
    end
  end

  class SimpleErrorMessageFormatter
    def format_message message
      message
    end
  end
end