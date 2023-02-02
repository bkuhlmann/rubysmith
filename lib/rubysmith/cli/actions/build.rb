# frozen_string_literal: true

module Rubysmith
  module CLI
    module Actions
      # Handles the build action.
      class Build
        include Rubysmith::Import[:logger]

        # Order is important.
        BUILDERS = [
          Builders::Core,
          Builders::Version,
          Builders::Documentation::Readme,
          Builders::Documentation::Citation,
          Builders::Documentation::License,
          Builders::Documentation::Version,
          Builders::Git::Setup,
          Builders::Git::Ignore,
          Builders::Git::Safe,
          Builders::Bundler,
          Builders::Rake,
          Builders::Console,
          Builders::CircleCI,
          Builders::Setup,
          Builders::GitHub,
          Builders::GitHubCI,
          Builders::Guard,
          Builders::Reek,
          Builders::RSpec::Binstub,
          Builders::RSpec::Context,
          Builders::RSpec::Helper,
          Builders::Caliber,
          Extensions::Bundler,
          Extensions::Pragmater,
          Extensions::Tocer,
          Extensions::Rubocop,
          Builders::Git::Commit
        ].freeze

        def initialize(builders: BUILDERS, **)
          super(**)
          @builders = builders
        end

        def call configuration
          log_info "Building project skeleton: #{configuration.project_name}..."
          builders.each { |builder| builder.call configuration }
          log_info "Project skeleton complete!"
        end

        private

        attr_reader :builders

        def log_info(message) = logger.info { message }
      end
    end
  end
end
