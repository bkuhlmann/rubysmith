# frozen_string_literal: true

module Rubysmith
  module Builders
    module Git
      # Initializes project skeleton as a Git repository.
      class Setup
        def self.call(configuration, builder: Builder) = new(configuration, builder: builder).call

        def initialize configuration, builder: Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          return unless configuration.build_git

          builder.call(configuration).run("git init", chdir: configuration.project_name)
        end

        private

        attr_reader :configuration, :builder
      end
    end
  end
end
