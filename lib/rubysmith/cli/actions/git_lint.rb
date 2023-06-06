# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Git Lint flag.
      class GitLint < Sod::Action
        include Import[:inputs]

        using ::Refinements::Structs

        description "Add Git Lint gem."

        on "--[no-]git-lint"

        default { Container[:configuration].build_git_lint }

        def call(value = default) = inputs.merge!(build_git_lint: value)
      end
    end
  end
end
