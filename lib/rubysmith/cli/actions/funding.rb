# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores funding flag.
      class Funding < Sod::Action
        include Import[:input]

        description "Add GitHub funding configuration."

        on "--[no-]funding"

        default { Container[:configuration].build_funding }

        def call(value = nil) = input.build_funding = value
      end
    end
  end
end
