# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Git flag.
      class Git < Sod::Action
        include Import[:input]

        using ::Refinements::Structs

        description "Add Git repository."

        on "--[no-]git"

        default { Container[:configuration].build_git }

        def call(value = default) = input.merge!(build_git: value)
      end
    end
  end
end