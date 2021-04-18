# frozen_string_literal: true

require "refinements/structs"

module Rubysmith
  module CLI
    module Processors
      # Handles the Command Line Interface (CLI) for building of a project skeleton.
      class Build
        using Refinements::Structs

        # Order is important.
        MINIMUM = [
          Builders::Core,
          Builders::Bundler,
          Builders::Pragma,
          Builders::Rubocop::Formatter
        ].freeze

        # Order is important.
        MAXIMUM = [
          Builders::Core,
          Builders::Documentation,
          Builders::Git::Setup,
          Builders::Bundler,
          Builders::Rake,
          Builders::Console,
          Builders::Setup,
          Builders::Guard,
          Builders::Reek,
          Builders::RSpec::Context,
          Builders::RSpec::Helper,
          Builders::Pragma,
          Builders::Rubocop::Setup,
          Builders::Rubocop::Formatter,
          Builders::RubyCritic,
          Builders::Git::Commit
        ].freeze

        def self.with_minimum
          new builders: MINIMUM
        end

        def initialize configuration: Configuration::Loader.call, builders: MAXIMUM
          @configuration = configuration
          @builders = builders
        end

        def call(options) = configuration.merge(**options).then { |config| process config }

        private

        attr_reader :configuration, :builders

        def process(config) = builders.each { |builder| builder.call config }
      end
    end
  end
end
