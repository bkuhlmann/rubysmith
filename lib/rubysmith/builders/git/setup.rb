# frozen_string_literal: true

module Rubysmith
  module Builders
    module Git
      # Initializes project skeleton as a Git repository.
      class Setup
        def self.call(...) = new(...).call

        def initialize configuration, builder: Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          return configuration unless configuration.build_git

          builder.call(configuration).run("git init", chdir: configuration.project_name)
          configuration
        end

        private

        attr_reader :configuration, :builder
      end
    end
  end
end
