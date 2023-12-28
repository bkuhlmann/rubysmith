# frozen_string_literal: true

require "refinements/struct"
require "sod"

module Rubysmith
  module CLI
    module Commands
      # Stores table of contents root path.
      class Build < Sod::Command
        include Import[:input, :kernel, :logger]

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

        handle "build"

        description "Build new project."

        on Actions::Name
        on Actions::AmazingPrint
        on Actions::Caliber
        on Actions::Console
        on Actions::Contributions
        on Actions::CircleCI
        on Actions::Citation
        on Actions::Community
        on Actions::Conduct
        on Actions::Debug
        on Actions::Funding
        on Actions::Git
        on Actions::GitHub
        on Actions::GitHubCI
        on Actions::GitLint
        on Actions::Guard
        on Actions::License
        on Actions::Maximum
        on Actions::Minimum
        on Actions::Rake
        on Actions::Readme
        on Actions::Reek
        on Actions::Refinements
        on Actions::RSpec
        on Actions::Security
        on Actions::Setup
        on Actions::SimpleCov
        on Actions::Versions
        on Actions::Yard
        on Actions::Zeitwerk

        def initialize(builders: BUILDERS, **)
          super(**)
          @builders = builders
        end

        def call
          log_info "Building project skeleton: #{input.project_name}..."
          builders.each { |builder| builder.call input }
          log_info "Project skeleton complete!"
        end

        private

        attr_reader :builders

        def log_info(message) = logger.info { message }
      end
    end
  end
end
