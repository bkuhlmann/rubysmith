# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Rake flag.
      class Rake < Sod::Action
        include Import[:settings]

        description "Add Rake gem."

        on "--[no-]rake"

        default { Container[:settings].build_rake }

        def call(value = nil) = settings.build_rake = value
      end
    end
  end
end
