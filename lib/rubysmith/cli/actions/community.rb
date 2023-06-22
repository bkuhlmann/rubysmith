# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores community flag.
      class Community < Sod::Action
        include Import[:input]

        description "Add community documentation."

        on "--[no-]community"

        default { Container[:configuration].build_community }

        def call(value = nil) = input.build_community = value
      end
    end
  end
end
