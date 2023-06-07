# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Guard flag.
      class Guard < Sod::Action
        include Import[:input]

        using ::Refinements::Structs

        description "Add Guard gem."

        on "--[no-]guard"

        default { Container[:configuration].build_guard }

        def call(value = default) = input.merge!(build_guard: value)
      end
    end
  end
end
