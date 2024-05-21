# frozen_string_literal: true

module Rubysmith
  module Builders
    # Provides default implementation from which builders can inherit from.
    class Abstract
      def self.call(...) = new(...).call

      def initialize configuration, builder: Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        fail NoMethodError,
             "`#{self.class}##{__method__} #{method(__method__).parameters}` must be implemented."
      end

      protected

      attr_reader :configuration, :builder
    end
  end
end
