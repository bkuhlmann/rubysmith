# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores license flag.
      class License < Sod::Action
        include Import[:input]

        description "Add license documentation."

        on "--[no-]license"

        default { Container[:configuration].build_license }

        def call(value = default) = input.build_license = value
      end
    end
  end
end
