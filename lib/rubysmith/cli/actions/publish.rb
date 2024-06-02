# frozen_string_literal: true

require "milestoner"
require "refinements/struct"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Publishes project.
      class Publish < Sod::Action
        include Import[:settings]

        using ::Refinements::Struct

        description "Publish milestone."

        on %w[-p --publish], argument: "[VERSION]"

        default { Milestoner::Commits::Versioner.new.call }

        def initialize(extension: Extensions::Milestoner, **)
          super(**)
          @extension = extension
        end

        def call version = nil
          settings.project_version = version || default
          extension.call
        end

        private

        attr_reader :extension
      end
    end
  end
end
