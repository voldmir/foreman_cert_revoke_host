module ActiveSupport
  module Concern
    class MultipleIncludedBlocks < StandardError
      def initialize
        super "Cannot define multiple 'included' blocks for a Concern"
      end
    end

    def append_features(base)
      super
      base.class_eval(&@_included_block) if instance_variable_defined?(:@_included_block)
    end

    def included(base = nil, &block)
      if base.nil?
        @_included_block = block
      else
        super
      end
    end
  end
end
