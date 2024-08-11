# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Caliber flag.
      class Caliber < Sod::Action
        include Import[:settings]

        description "Add Caliber gem."

        on "--[no-]caliber"

        default { Container[:settings].build_caliber }

        def call(boolean) = settings.build_caliber = boolean
      end
    end
  end
end
