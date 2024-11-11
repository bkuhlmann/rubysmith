# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Docker flag.
      class Docker < Sod::Action
        include Dependencies[:settings]

        description "Add Docker support."

        on "--[no-]docker"

        default { Container[:settings].build_docker }

        def call(boolean) = settings.build_docker = boolean
      end
    end
  end
end
