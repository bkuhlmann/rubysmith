# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores security flag.
      class Security < Sod::Action
        include Import[:settings]

        description "Add security."

        on "--[no-]security"

        default { Container[:settings].build_security }

        def call(value = nil) = settings.build_security = value
      end
    end
  end
end
