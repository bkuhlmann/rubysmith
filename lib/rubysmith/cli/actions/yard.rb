# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Yard flag.
      class Yard < Sod::Action
        include Import[:inputs]

        using ::Refinements::Structs

        description "Add Yard gem."

        on "--[no-]yard"

        default { Container[:configuration].build_yard }

        def call(value = default) = inputs.merge!(build_yard: value)
      end
    end
  end
end
