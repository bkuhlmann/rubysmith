# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores GitHub flag.
      class GitHub < Sod::Action
        include Dependencies[:settings]

        description "Add GitHub code review and issue templates."

        on "--[no-]git_hub"

        default { Container[:settings].build_git_hub }

        def call(boolean) = settings.build_git_hub = boolean
      end
    end
  end
end
