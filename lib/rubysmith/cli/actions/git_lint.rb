# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Git Lint flag.
      class GitLint < Sod::Action
        include Import[:settings]

        description "Add Git Lint gem."

        on "--[no-]git-lint"

        default { Container[:settings].build_git_lint }

        def call(value = nil) = settings.build_git_lint = value
      end
    end
  end
end
