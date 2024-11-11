# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores console flag.
      class Console < Sod::Action
        include Dependencies[:settings]

        description "Add console script."

        on "--[no-]console"

        default { Container[:settings].build_console }

        def call(boolean) = settings.build_console = boolean
      end
    end
  end
end
