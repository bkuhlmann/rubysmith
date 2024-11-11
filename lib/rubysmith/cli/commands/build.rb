# frozen_string_literal: true

require "refinements/struct"
require "sod"

module Rubysmith
  module CLI
    module Commands
      # Stores table of contents root path.
      class Build < Sod::Command
        include Dependencies[:settings, :kernel, :logger]

        # Order is important.
        BUILDERS = [
          Builders::Init,
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
          Builders::Rake::Binstub,
          Builders::Rake::Configuration,
          Builders::Console,
          Builders::CircleCI,
          Builders::Setup,
          Builders::GitHub::Template,
          Builders::GitHub::Funding,
          Builders::GitHub::CI,
          Builders::Reek,
          Builders::RSpec::Binstub,
          Builders::RSpec::Context,
          Builders::RSpec::Helper,
          Builders::Caliber,
          Builders::DevContainer::Dockerfile,
          Builders::DevContainer::Compose,
          Builders::DevContainer::Configuration,
          Builders::Docker::Build,
          Builders::Docker::Console,
          Builders::Docker::Entrypoint,
          Builders::Docker::File,
          Builders::Docker::Ignore,
          Extensions::Bundler,
          Extensions::Pragmater,
          Extensions::Tocer,
          Extensions::Rubocop,
          Builders::Git::Commit
        ].freeze

        handle "build"

        description "Build new project."

        on Actions::Name
        on Actions::AmazingPrint
        on Actions::Bootsnap
        on Actions::Caliber
        on Actions::CircleCI
        on Actions::Citation
        on Actions::Community
        on Actions::Conduct
        on Actions::Console
        on Actions::Contributions
        on Actions::DCOO
        on Actions::Debug
        on Actions::DevContainer
        on Actions::Docker
        on Actions::Funding
        on Actions::Git
        on Actions::GitHub
        on Actions::GitHubCI
        on Actions::GitLint
        on Actions::IRBKit
        on Actions::License
        on Actions::Maximum
        on Actions::Minimum
        on Actions::Rake
        on Actions::Readme
        on Actions::Reek
        on Actions::Refinements
        on Actions::RSpec
        on Actions::RTC
        on Actions::Security
        on Actions::Setup
        on Actions::SimpleCov
        on Actions::Versions
        on Actions::Zeitwerk

        def initialize(builders: BUILDERS, **)
          super(**)
          @builders = builders
        end

        def call
          log_info "Building project skeleton: #{settings.project_name}..."
          builders.each { |builder| builder.new(settings:, logger:).call }
          log_info "Project skeleton complete!"
        end

        private

        attr_reader :builders

        def log_info(message) = logger.info { message }
      end
    end
  end
end
