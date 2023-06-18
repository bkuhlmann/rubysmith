# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores setup flag.
      class Setup < Sod::Action
        include Import[:input]

        description "Add setup script."

        on "--[no-]setup"

        default { Container[:configuration].build_setup }

        def call(value = default) = input.build_setup = value
      end
    end
  end
end
