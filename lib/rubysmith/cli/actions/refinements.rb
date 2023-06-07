# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Refinements flag.
      class Refinements < Sod::Action
        include Import[:input]

        using ::Refinements::Structs

        description "Add Refinements gem."

        on "--[no-]refinements"

        default { Container[:configuration].build_refinements }

        def call(value = default) = input.merge!(build_refinements: value)
      end
    end
  end
end
