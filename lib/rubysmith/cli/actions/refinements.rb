# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Refinements flag.
      class Refinements < Sod::Action
        include Import[:input]

        description "Add Refinements gem."

        on "--[no-]refinements"

        default { Container[:configuration].build_refinements }

        def call(value = default) = input.build_refinements = value
      end
    end
  end
end
