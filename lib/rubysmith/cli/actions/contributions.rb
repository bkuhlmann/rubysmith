# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores contributions flag.
      class Contributions < Sod::Action
        include Import[:inputs]

        using ::Refinements::Structs

        description "Add contributions documentation."

        on "--[no-]contributions"

        default { Container[:configuration].build_contributions }

        def call(value = default) = inputs.merge!(build_contributions: value)
      end
    end
  end
end
