# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores GitHub CI flag.
      class GitHubCI < Sod::Action
        include Import[:input]

        using ::Refinements::Structs

        description "Add GitHub continuous integration."

        on "--[no-]git_hub_ci"

        default { Container[:configuration].build_git_hub_ci }

        def call(value = default) = input.merge!(build_git_hub_ci: value)
      end
    end
  end
end
