# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores GitHub CI flag.
      class GitHubCI < Sod::Action
        include Dependencies[:settings]

        description "Add GitHub continuous integration support."

        on "--[no-]git_hub_ci"

        default { Container[:settings].build_git_hub_ci }

        def call(boolean) = settings.build_git_hub_ci = boolean
      end
    end
  end
end
