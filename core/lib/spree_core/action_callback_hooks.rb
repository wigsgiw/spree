module Spree
  module ActionCallbackHooks
    module ClassMethods
      attr_accessor :callbacks

      def index
        @callbacks ||= {}
        @callbacks[:index] ||= Spree::ActionCallbacks.new
      end

      def new_action
        @callbacks ||= {}
        @callbacks[:new_action] ||= Spree::ActionCallbacks.new
      end

      def show
        @callbacks ||= {}
        @callbacks[:show] ||= Spree::ActionCallbacks.new
      end

      def create
        @callbacks ||= {}
        @callbacks[:create] ||= Spree::ActionCallbacks.new
      end

      def edit
        @callbacks ||= {}
        @callbacks[:edit] ||= Spree::ActionCallbacks.new
      end

      def update
        @callbacks ||= {}
        @callbacks[:update] ||= Spree::ActionCallbacks.new
      end

      def destroy
        @callbacks ||= {}
        @callbacks[:destroy] ||= Spree::ActionCallbacks.new
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    def invoke_callbacks(action, callback_type)
      callbacks = self.class.callbacks || {}
      return if callbacks[action].nil?
      to_exec = case callback_type.to_sym
        when :before then callbacks[action].befores
        when :after  then callbacks[action].afters
        when :fail  then callbacks[action].fails
      end

      unless to_exec.empty?
        to_exec.select { |callback| callback.is_a? Symbol }.each { |symbol| send(symbol) }

        block = to_exec.detect { |callback| callback.is_a? Proc }
        instance_eval &block unless block.nil?
      end
    end

  end
end
