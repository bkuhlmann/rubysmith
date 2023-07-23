# frozen_string_literal: true

require "dry/monads"
require "refinements/arrays"

module Rubysmith
  module Configuration
    module Transformers
      # Appends custom content to default template roots.
      class TemplateRoot
        include Dry::Monads[:result]

        using Refinements::Arrays

        def initialize key = :template_roots, default: Pathname(__dir__).join("../../templates")
          @key = key
          @default = default
        end

        def call content
          Array(default).map { |path| Pathname path }
                        .including(content[key])
                        .compact
                        .then { |value| Success content.merge!(key => value) }
        end

        private

        attr_reader :key, :default
      end
    end
  end
end
