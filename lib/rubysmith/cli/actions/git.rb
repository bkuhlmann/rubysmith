# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Git flag.
      class Git < Sod::Action
        include Import[:input]

        description "Add Git repository."

        on "--[no-]git"

        default { Container[:configuration].build_git }

        def call(value = nil) = input.build_git = value
      end
    end
  end
end
