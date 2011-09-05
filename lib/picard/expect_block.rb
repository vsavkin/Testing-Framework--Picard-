module Picard
  class ExpectBlock
    def self.invoke *args
      yield *args
    end
  end
end