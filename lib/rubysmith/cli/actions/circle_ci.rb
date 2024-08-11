# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Circle CI flag.
      class CircleCI < Sod::Action
        include Import[:settings]

        description "Add Circle CI settings."

        on "--[no-]circle_ci"

        default { Container[:settings].build_circle_ci }

        def call(boolean) = settings.build_circle_ci = boolean
      end
    end
  end
end
