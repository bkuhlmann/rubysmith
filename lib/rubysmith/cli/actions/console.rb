# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores console flag.
      class Console < Sod::Action
        include Import[:input]

        description "Add console script."

        on "--[no-]console"

        default { Container[:configuration].build_console }

        def call(value = nil) = input.build_console = value
      end
    end
  end
end
