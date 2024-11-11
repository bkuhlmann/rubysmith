# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores setup flag.
      class Setup < Sod::Action
        include Dependencies[:settings]

        description "Add setup script."

        on "--[no-]setup"

        default { Container[:settings].build_setup }

        def call(boolean) = settings.build_setup = boolean
      end
    end
  end
end
