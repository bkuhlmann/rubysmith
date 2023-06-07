# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores community flag.
      class Community < Sod::Action
        include Import[:input]

        using ::Refinements::Structs

        description "Add community documentation."

        on "--[no-]community"

        default { Container[:configuration].build_community }

        def call(value = default) = input.merge!(build_community: value)
      end
    end
  end
end
