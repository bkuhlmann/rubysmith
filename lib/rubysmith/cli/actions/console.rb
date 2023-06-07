# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores console flag.
      class Console < Sod::Action
        include Import[:input]

        using ::Refinements::Structs

        description "Add console script."

        on "--[no-]console"

        default { Container[:configuration].build_console }

        def call(value = default) = input.merge!(build_console: value)
      end
    end
  end
end
