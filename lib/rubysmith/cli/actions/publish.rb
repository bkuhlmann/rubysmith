# frozen_string_literal: true

module Rubysmith
  module CLI
    module Actions
      # Handles parsing of Command Line Interface (CLI) publish options.
      class Publish
        def initialize extension: Extensions::Milestoner, container: Container
          @extension = extension
          @container = container
        end

        def call(configuration) = extension.call(configuration)

        private

        attr_reader :extension, :container
      end
    end
  end
end
