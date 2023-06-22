# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores security flag.
      class Security < Sod::Action
        include Import[:input]

        description "Add security."

        on "--[no-]security"

        default { Container[:configuration].build_security }

        def call(value = nil) = input.build_security = value
      end
    end
  end
end
