module Picard
  module SExpressionSugar
    def s *args
      Sexp.new *args
    end
  end
end