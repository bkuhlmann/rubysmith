# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores contributions flag.
      class Contributions < Sod::Action
        include Import[:input]

        description "Add contributions documentation."

        on "--[no-]contributions"

        default { Container[:configuration].build_contributions }

        def call(value = default) = input.build_contributions = value
      end
    end
  end
end
