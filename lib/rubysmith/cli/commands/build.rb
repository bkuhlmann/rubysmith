# frozen_string_literal: true

require "refinements/struct"
require "sod"

module Rubysmith
  module CLI
    module Commands
      # Stores table of contents root path.
      class Build < Sod::Command
        include Import[:settings, :kernel, :logger]

        # Order is important.
        BUILDERS = [
          Builders::Init.new,
          Builders::Core.new,
          Builders::Version.new,
          Builders::Documentation::Readme.new,
          Builders::Documentation::Citation.new,
          Builders::Documentation::License.new,
          Builders::Documentation::Version.new,
          Builders::Git::Setup.new,
          Builders::Git::Ignore.new,
          Builders::Git::Safe.new,
          Builders::Bundler.new,
          Builders::Rake::Binstub.new,
          Builders::Rake::Configuration.new,
          Builders::Console.new,
          Builders::CircleCI.new,
          Builders::Setup.new,
          Builders::GitHub::Template.new,
          Builders::GitHub::Funding.new,
          Builders::GitHub::CI.new,
          Builders::Guard.new,
          Builders::Reek.new,
          Builders::RSpec::Binstub.new,
          Builders::RSpec::Context.new,
          Builders::RSpec::Helper.new,
          Builders::Caliber.new,
          Extensions::Bundler.new,
          Extensions::Pragmater.new,
          Extensions::Tocer.new,
          Extensions::Rubocop.new,
          Builders::Git::Commit.new
        ].freeze

        handle "build"

        description "Build new project."

        on Actions::Name
        on Actions::AmazingPrint
        on Actions::Bootsnap
        on Actions::Caliber
        on Actions::Console
        on Actions::Contributions
        on Actions::CircleCI
        on Actions::Citation
        on Actions::Community
        on Actions::Conduct
        on Actions::DCOO
        on Actions::Debug
        on Actions::Funding
        on Actions::Git
        on Actions::GitHub
        on Actions::GitHubCI
        on Actions::GitLint
        on Actions::Guard
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
          builders.each(&:call)
          log_info "Project skeleton complete!"
        end

        private

        attr_reader :builders

        def log_info(message) = logger.info { message }
      end
    end
  end
end
