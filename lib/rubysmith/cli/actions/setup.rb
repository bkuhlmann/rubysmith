# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores setup flag.
      class Setup < Sod::Action
        include Import[:settings]

        description "Add setup script."

        on "--[no-]setup"

        default { Container[:settings].build_setup }

        def call(value = nil) = settings.build_setup = value
      end
    end
  end
end
