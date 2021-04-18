# frozen_string_literal: true

require "refinements/hashes"

module Rubysmith
  module CLI
    # The main Command Line Interface (CLI) object.
    class Shell
      using Refinements::Hashes

      PROCESSORS = {
        config: Processors::Config.new,
        build_minimum: Processors::Build.with_minimum,
        build_maximum: Processors::Build.new
      }.freeze

      def initialize parser: Parsers::Assembler.new, processors: PROCESSORS
        @parser = parser
        @processors = processors
      end

      def call arguments = []
        parse arguments

        case options
          in config: Symbol => action then process_config action
          in build_minimum: true then process_build :build_minimum, options
          in build: then process_build :build_maximum, options
          in version: String => version then puts version
          in help: then usage
          else usage
        end
      end

      private

      attr_reader :parser, :processors

      def parse arguments = []
        parser.call arguments
      rescue StandardError => error
        puts error.message
      end

      def process_config(action) = processors.fetch(:config).call(action)

      def process_build kind, settings
        processors.fetch(kind).call settings.transform_keys(build: :project_name)
                                            .merge(now: Time.now)
      end

      def options = parser.to_h

      def usage = puts(parser.to_s)
    end
  end
end
