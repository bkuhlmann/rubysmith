# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores GitHub flag.
      class GitHub < Sod::Action
        include Import[:inputs]

        using ::Refinements::Structs

        description "Add GitHub templates."

        on "--[no-]git_hub"

        default { Container[:configuration].build_git_hub }

        def call(value = default) = inputs.merge!(build_git_hub: value)
      end
    end
  end
end
