# frozen_string_literal: true

require "refinements/structs"

module Rubysmith
  module Builders
    module Git
      # Builds Git repository directory and file ignore configuration.
      class Ignore
        using Refinements::Structs

        def self.call(...) = new(...).call

        def initialize configuration, builder: Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          return configuration unless configuration.build_git

          builder.call(configuration.merge(template_path: "%project_name%/.gitignore.erb"))
                 .render
                 .replace("  ", "")

          configuration
        end

        private

        attr_reader :configuration, :builder
      end
    end
  end
end
