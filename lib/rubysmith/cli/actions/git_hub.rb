# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores GitHub flag.
      class GitHub < Sod::Action
        include Import[:settings]

        description "Add GitHub templates."

        on "--[no-]git_hub"

        default { Container[:settings].build_git_hub }

        def call(value = nil) = settings.build_git_hub = value
      end
    end
  end
end
