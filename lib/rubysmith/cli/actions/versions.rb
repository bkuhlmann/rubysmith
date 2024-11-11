# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores versions flag.
      class Versions < Sod::Action
        include Dependencies[:settings]

        description "Add version history."

        on "--[no-]versions"

        default { Container[:settings].build_versions }

        def call(boolean) = settings.build_versions = boolean
      end
    end
  end
end
