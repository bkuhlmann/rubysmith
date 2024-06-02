# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores GitHub CI flag.
      class GitHubCI < Sod::Action
        include Import[:settings]

        description "Add GitHub continuous integration."

        on "--[no-]git_hub_ci"

        default { Container[:settings].build_git_hub_ci }

        def call(value = nil) = settings.build_git_hub_ci = value
      end
    end
  end
end
