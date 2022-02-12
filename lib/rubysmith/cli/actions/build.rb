# frozen_string_literal: true

module Rubysmith
  module CLI
    module Actions
      # Handles the build action.
      class Build
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
          Builders::Caliber,
          Extensions::Bundler,
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
