# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Forces minimum configuration.
      class Minimum < Sod::Action
        include Import[:inputs]

        using ::Refinements::Structs

        description "Use minimum options."

        on "--min"

        default { Container[:configuration].build_minimum }

        def call(*) = inputs.merge!(inputs.minimize)
      end
    end
  end
end
