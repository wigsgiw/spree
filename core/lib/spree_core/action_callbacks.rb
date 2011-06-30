module Spree
  class ActionCallbacks
    attr_reader :befores
    attr_reader :afters
    attr_reader :fails

    def initialize
      @befores = []
      @afters = []
      @fails = []
    end

    def before(method=nil, &block)
      @befores << (block_given? ? block : method)
    end

    def after(method=nil, &block)
      @afters << (block_given? ? block : method)
    end

    def fail(method=nil, &block)
      @fails << (block_given? ? block : method)
    end

    def response(*args, &block)
      puts "[WARNING] Support for action.response has been removed, please use \"respond_override\" instead."
      puts "         The custom response defined by \"#{caller[0]}\" will be IGNORED."
    end
  end

end
