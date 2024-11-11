# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores project (build) name.
      class Name < Sod::Action
        include Dependencies[:settings]

        description "Set project name."

        on %w[-n --name], argument: "NAME"

        def call(name) = settings.project_name = name
      end
    end
  end
end
