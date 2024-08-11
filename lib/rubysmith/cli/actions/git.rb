# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Git flag.
      class Git < Sod::Action
        include Import[:settings]

        description "Add Git repository."

        on "--[no-]git"

        default { Container[:settings].build_git }

        def call(boolean) = settings.build_git = boolean
      end
    end
  end
end
