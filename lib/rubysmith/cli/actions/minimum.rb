# frozen_string_literal: true

require "refinements/struct"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Forces minimum settings.
      class Minimum < Sod::Action
        include Import[:settings]

        using ::Refinements::Struct

        description "Use minimum configuration."

        on "--min"

        default { Container[:settings].build_minimum }

        def call(*) = settings.merge! settings.minimize
      end
    end
  end
end
