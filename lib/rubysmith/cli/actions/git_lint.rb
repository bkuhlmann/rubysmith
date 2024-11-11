# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Git Lint flag.
      class GitLint < Sod::Action
        include Dependencies[:settings]

        description "Add Git Lint gem."

        on "--[no-]git-lint"

        default { Container[:settings].build_git_lint }

        def call(boolean) = settings.build_git_lint = boolean
      end
    end
  end
end
