require 'sourcify'

module Picard
  class ::Object
    def metaclass; class << self; self; end; end
    def meta_eval &blk; metaclass.instance_eval &blk; end

    def meta_def name, &blk
      meta_eval { define_method name, &blk }
    end
  end

  ::UnboundMethod.class_eval do
    include Sourcify::Method
  end
end
