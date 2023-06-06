# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Reek flag.
      class Reek < Sod::Action
        include Import[:inputs]

        using ::Refinements::Structs

        description "Add Reek gem."

        on "--[no-]reek"

        default { Container[:configuration].build_reek }

        def call(value = default) = inputs.merge!(build_reek: value)
      end
    end
  end
end
