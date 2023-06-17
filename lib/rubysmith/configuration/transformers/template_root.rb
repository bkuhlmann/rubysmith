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

        def initialize default = Pathname(__dir__).join("../../templates")
          @default = default
        end

        def call content
          Array(default).map { |path| Pathname path }
                        .including(content[:template_roots])
                        .compact
                        .then { |paths| Success content.merge!(template_roots: paths) }
        end

        private

        attr_reader :default
      end
    end
  end
end
