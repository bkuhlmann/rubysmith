# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores project (build) name.
      class Name < Sod::Action
        include Import[:input]

        using ::Refinements::Structs

        description "Set project name."

        on %w[-n --name], argument: "NAME"

        def call(name) = input.merge!(project_name: name)
      end
    end
  end
end
