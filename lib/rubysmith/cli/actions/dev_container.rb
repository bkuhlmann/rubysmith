# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Development Container flag.
      class DevContainer < Sod::Action
        include Dependencies[:settings, :logger]

        description "Add Development Container support."

        ancillary "DEPRECATED: Will be removed in Version 9.0.0."

        on "--[no-]devcontainer"

        default { Container[:settings].build_devcontainer }

        def call boolean
          logger.warn { "Dev Container support will be removed in Version 9.0.0." }
          settings.build_devcontainer = boolean
        end
      end
    end
  end
end
