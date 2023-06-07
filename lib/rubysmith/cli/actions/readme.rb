# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores readme flag.
      class Readme < Sod::Action
        include Import[:input]

        using ::Refinements::Structs

        description "Add readme documentation."

        on "--[no-]readme"

        default { Container[:configuration].build_readme }

        def call(value = default) = input.merge!(build_readme: value)
      end
    end
  end
end
