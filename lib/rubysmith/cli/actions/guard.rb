# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Guard flag.
      class Guard < Sod::Action
        include Import[:input]

        description "Add Guard gem."

        on "--[no-]guard"

        default { Container[:configuration].build_guard }

        def call(value = nil) = input.build_guard = value
      end
    end
  end
end
