# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Development Container flag.
      class DevContainer < Sod::Action
        include Import[:settings]

        description "Add Development Container support."

        on "--[no-]devcontainer"

        default { Container[:settings].build_devcontainer }

        def call(boolean) = settings.build_devcontainer = boolean
      end
    end
  end
end
