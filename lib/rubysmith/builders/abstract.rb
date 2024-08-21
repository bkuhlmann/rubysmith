# frozen_string_literal: true

module Rubysmith
  module Builders
    # Provides default implementation from which builders can inherit from.
    class Abstract
      include Import[:settings, :logger]

      def initialize(builder: Builder, **)
        @builder = -> settings, **keywords { builder.new settings, logger:, **keywords }
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
