# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores contributions flag.
      class Contributions < Sod::Action
        include Import[:settings]

        description "Add contributions documentation."

        on "--[no-]contributions"

        default { Container[:settings].build_contributions }

        def call(boolean) = settings.build_contributions = boolean
      end
    end
  end
end
