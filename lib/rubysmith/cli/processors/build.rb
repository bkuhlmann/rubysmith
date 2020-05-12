# frozen_string_literal: true

module Rubysmith
  module CLI
    module Processors
      # Order is important.
      BUILDERS = [
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
        Builders::Rubocop,
        Builders::Git::Commit
      ].freeze

      # Handles the Command Line Interface (CLI) for building of a project skeleton.
      class Build
        def initialize builders: BUILDERS
          @builders = builders
        end

        def call options
          Realm[**options].then(&method(:process))
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
