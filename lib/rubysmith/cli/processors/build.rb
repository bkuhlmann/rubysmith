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

        def initialize builders: MAXIMUM
          @builders = builders
        end

        def call options
          Realm[**options].then { |realm| process realm }
        end

        private

        attr_reader :builders

        def process realm
          builders.each { |builder| builder.call realm }
        end
      end
    end
  end
end
