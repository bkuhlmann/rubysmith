# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores funding flag.
      class Funding < Sod::Action
        include Import[:input]

        using ::Refinements::Structs

        description "Add GitHub funding configuration."

        on "--[no-]funding"

        default { Container[:configuration].build_funding }

        def call(value = default) = input.merge!(build_funding: value)
      end
    end
  end
end
