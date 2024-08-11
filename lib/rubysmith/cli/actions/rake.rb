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

        def call(boolean) = settings.build_rake = boolean
      end
    end
  end
end
