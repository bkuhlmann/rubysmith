# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Guard flag.
      class Guard < Sod::Action
        include Import[:settings]

        description "Add Guard gem."

        ancillary "DEPRECATED: Will be removed in next major version."

        on "--[no-]guard"

        default { Container[:settings].build_guard }

        def call(value = nil) = settings.build_guard = value
      end
    end
  end
end
