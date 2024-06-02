# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores readme flag.
      class Readme < Sod::Action
        include Import[:settings]

        description "Add readme documentation."

        on "--[no-]readme"

        default { Container[:settings].build_readme }

        def call(value = nil) = settings.build_readme = value
      end
    end
  end
end
