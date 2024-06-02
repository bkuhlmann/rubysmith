# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Refinements flag.
      class Refinements < Sod::Action
        include Import[:settings]

        description "Add Refinements gem."

        on "--[no-]refinements"

        default { Container[:settings].build_refinements }

        def call(value = nil) = settings.build_refinements = value
      end
    end
  end
end
