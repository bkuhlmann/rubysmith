# frozen_string_literal: true

module Rubysmith
  module CLI
    module Actions
      # Handles the build action.
      class Build
        # Order is important.
        BUILDERS = [
          Builders::Core,
          Builders::Documentation::Readme,
          Builders::Documentation::Change,
          Builders::Documentation::Citation,
          Builders::Documentation::Conduct,
          Builders::Documentation::Contribution,
          Builders::Documentation::License,
          Builders::Git::Setup,
          Builders::Bundler,
          Builders::Rake,
          Builders::Console,
          Builders::CircleCI,
          Builders::Setup,
          Builders::GitHub,
          Builders::Guard,
          Builders::Reek,
          Builders::RSpec::Context,
          Builders::RSpec::Helper,
          Builders::Rubocop,
          Builders::Rubocop::Setup,
          Extensions::Pragmater,
          Extensions::Tocer,
          Extensions::Rubocop,
          Builders::Git::Commit
        ].freeze

        def initialize builders: BUILDERS
          @builders = builders
        end

        def call(configuration) = builders.each { |builder| builder.call configuration }

        private

        attr_reader :configuration, :builders
      end
    end
  end
end
