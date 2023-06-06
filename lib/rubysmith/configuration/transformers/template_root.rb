# frozen_string_literal: true

require "dry/monads"
require "refinements/arrays"

module Rubysmith
  module Configuration
    # Prepends template roots to existing content.
    module Transformers
      include Dry::Monads[:result]

      using Refinements::Arrays

      TemplateRoot = lambda do |content, overrides: Pathname(__dir__).join("../../templates")|
        Array(overrides).map { |path| Pathname path }
                        .including(content[:template_roots])
                        .compact
                        .then { |paths| Dry::Monads::Success content.merge!(template_roots: paths) }
      end
    end
  end
end
