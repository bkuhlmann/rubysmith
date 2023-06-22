# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores versions flag.
      class Versions < Sod::Action
        include Import[:input]

        description "Add version history."

        on "--[no-]versions"

        default { Container[:configuration].build_versions }

        def call(value = nil) = input.build_versions = value
      end
    end
  end
end
