# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores versions flag.
      class Versions < Sod::Action
        include Import[:settings]

        description "Add version history."

        on "--[no-]versions"

        default { Container[:settings].build_versions }

        def call(value = nil) = settings.build_versions = value
      end
    end
  end
end
