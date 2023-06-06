# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores security flag.
      class Security < Sod::Action
        include Import[:inputs]

        using ::Refinements::Structs

        description "Add security."

        on "--[no-]security"

        default { Container[:configuration].build_security }

        def call(value = default) = inputs.merge!(build_security: value)
      end
    end
  end
end
