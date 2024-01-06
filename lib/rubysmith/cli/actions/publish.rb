# frozen_string_literal: true

require "milestoner"
require "refinements/struct"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Publishes project.
      class Publish < Sod::Action
        include Import[:input]

        using ::Refinements::Struct

        description "Publish milestone."

        on %w[-p --publish], argument: "[VERSION]"

        default { Milestoner::Commits::Versioner.new.call }

        def initialize(extension: Extensions::Milestoner, **)
          super(**)
          @extension = extension
        end

        def call(version = nil) = extension.call input.merge(project_version: version || default)

        private

        attr_reader :extension
      end
    end
  end
end
