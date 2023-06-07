# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Publishes project.
      class Publish < Sod::Action
        include Import[:configuration]

        using ::Refinements::Structs

        description "Publish project."

        on %w[-p --publish], argument: "VERSION"

        def initialize(extension: Extensions::Milestoner, **)
          super(**)
          @extension = extension
        end

        def call(version) = extension.call configuration.merge(project_version: version)

        private

        attr_reader :extension
      end
    end
  end
end
