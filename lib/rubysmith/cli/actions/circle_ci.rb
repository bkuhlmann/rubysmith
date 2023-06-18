# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Circle CI flag.
      class CircleCI < Sod::Action
        include Import[:input]

        description "Add Circle CI configuration."

        on "--[no-]circle_ci"

        default { Container[:configuration].build_circle_ci }

        def call(value = default) = input.build_circle_ci = value
      end
    end
  end
end
