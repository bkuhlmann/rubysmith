# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores security flag.
      class Security < Sod::Action
        include Dependencies[:settings]

        description "Add security."

        on "--[no-]security"

        default { Container[:settings].build_security }

        def call(boolean) = settings.build_security = boolean
      end
    end
  end
end
