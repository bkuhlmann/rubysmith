# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Caliber flag.
      class Caliber < Sod::Action
        include Import[:input]

        using ::Refinements::Structs

        description "Add Caliber gem."

        on "--[no-]caliber"

        default { Container[:configuration].build_caliber }

        def call(value = default) = input.merge!(build_caliber: value)
      end
    end
  end
end
