# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Forces maximum configuration.
      class Maximum < Sod::Action
        include Import[:inputs]

        using ::Refinements::Structs

        description "Use maximum options."

        on "--max"

        default { Container[:configuration].build_maximum }

        def call(*) = inputs.merge!(inputs.maximize)
      end
    end
  end
end
