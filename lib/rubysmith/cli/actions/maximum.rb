# frozen_string_literal: true

require "refinements/struct"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Forces maximum configuration.
      class Maximum < Sod::Action
        include Import[:input]

        using ::Refinements::Struct

        description "Use maximum options."

        on "--max"

        default { Container[:configuration].build_maximum }

        def call(*) = input.merge! input.maximize
      end
    end
  end
end
