# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores community flag.
      class Community < Sod::Action
        include Import[:settings]

        description "Add community documentation."

        on "--[no-]community"

        default { Container[:settings].build_community }

        def call(boolean) = settings.build_community = boolean
      end
    end
  end
end
