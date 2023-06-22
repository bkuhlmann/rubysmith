# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Caliber flag.
      class Caliber < Sod::Action
        include Import[:input]

        description "Add Caliber gem."

        on "--[no-]caliber"

        default { Container[:configuration].build_caliber }

        def call(value = nil) = input.build_caliber = value
      end
    end
  end
end
