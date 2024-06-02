# frozen_string_literal: true

module Rubysmith
  module Builders
    # Provides default implementation from which builders can inherit from.
    class Abstract
      include Import[:settings]

      def self.call(...) = new(...).call

      def initialize(builder: Builder, **)
        @builder = builder
        super(**)
      end

      def call
        fail NoMethodError,
             "`#{self.class}##{__method__} #{method(__method__).parameters}` must be implemented."
      end

      protected

      attr_reader :builder
    end
  end
end
