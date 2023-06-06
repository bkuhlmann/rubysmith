# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores setup flag.
      class Setup < Sod::Action
        include Import[:inputs]

        using ::Refinements::Structs

        description "Add setup script."

        on "--[no-]setup"

        default { Container[:configuration].build_setup }

        def call(value = default) = inputs.merge!(build_setup: value)
      end
    end
  end
end
