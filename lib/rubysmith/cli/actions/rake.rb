# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Rake flag.
      class Rake < Sod::Action
        include Import[:input]

        description "Add Rake gem."

        on "--[no-]rake"

        default { Container[:configuration].build_rake }

        def call(value = default) = input.build_rake = value
      end
    end
  end
end
