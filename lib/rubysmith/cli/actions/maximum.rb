# frozen_string_literal: true

require "refinements/struct"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Forces maximum settings.
      class Maximum < Sod::Action
        include Dependencies[:settings]

        using ::Refinements::Struct

        description "Use maximum configuration."

        on "--max"

        default { Container[:settings].build_maximum }

        def call(*) = settings.merge! settings.maximize
      end
    end
  end
end
