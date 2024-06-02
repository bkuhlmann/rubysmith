# frozen_string_literal: true

require "refinements/struct"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Forces maximum settings.
      class Maximum < Sod::Action
        include Import[:settings]

        using ::Refinements::Struct

        description "Use maximum options."

        on "--max"

        default { Container[:settings].build_maximum }

        def call(*) = settings.merge! settings.maximize
      end
    end
  end
end
