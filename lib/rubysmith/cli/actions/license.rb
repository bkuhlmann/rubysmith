# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores license flag.
      class License < Sod::Action
        include Import[:settings]

        description "Add license documentation."

        on "--[no-]license"

        default { Container[:settings].build_license }

        def call(value = nil) = settings.build_license = value
      end
    end
  end
end
