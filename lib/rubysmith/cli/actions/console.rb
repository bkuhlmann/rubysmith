# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores console flag.
      class Console < Sod::Action
        include Import[:settings]

        description "Add console script."

        on "--[no-]console"

        default { Container[:settings].build_console }

        def call(value = nil) = settings.build_console = value
      end
    end
  end
end
