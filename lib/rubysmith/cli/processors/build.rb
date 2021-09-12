# frozen_string_literal: true

module Rubysmith
  module CLI
    module Processors
      # Handles the Command Line Interface (CLI) for building of a project skeleton.
      class Build
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
          Builders::Git::Commit
        ].freeze

        def self.with_minimum = new(builders: MINIMUM)

        def initialize builders: MAXIMUM, container: Container
          @builders = builders
          @container = container
        end

        def call = builders.each { |builder| builder.call configuration }

        private

        attr_reader :builders, :container

        def configuration = container[__method__]
      end
    end
  end
end
