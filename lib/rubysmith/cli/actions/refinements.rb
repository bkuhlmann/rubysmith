# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Refinements flag.
      class Refinements < Sod::Action
        include Dependencies[:settings]

        description "Add Refinements gem."

        on "--[no-]refinements"

        default { Container[:settings].build_refinements }

        def call(boolean) = settings.build_refinements = boolean
      end
    end
  end
end
