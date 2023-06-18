# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores GitHub flag.
      class GitHub < Sod::Action
        include Import[:input]

        description "Add GitHub templates."

        on "--[no-]git_hub"

        default { Container[:configuration].build_git_hub }

        def call(value = default) = input.build_git_hub = value
      end
    end
  end
end
