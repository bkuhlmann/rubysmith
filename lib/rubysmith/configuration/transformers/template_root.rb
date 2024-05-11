# frozen_string_literal: true

require "dry/monads"
require "refinements/array"

module Rubysmith
  module Configuration
    module Transformers
      # Appends custom path to default template roots.
      class TemplateRoot
        include Dry::Monads[:result]

        using Refinements::Array

        def initialize key = :template_roots, default: Pathname(__dir__).join("../../templates")
          @key = key
          @default = default
        end

        def call attributes
          Array(default).map { |path| Pathname path }
                        .including(attributes[key])
                        .compact
                        .then { |value| Success attributes.merge!(key => value) }
        end

        private

        attr_reader :key, :default
      end
    end
  end
end
