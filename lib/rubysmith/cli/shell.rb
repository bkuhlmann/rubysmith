# frozen_string_literal: true

require "optparse"
require "refinements/hashes"

module Rubysmith
  module CLI
    # Represents the Command Line Interface (CLI) for this gem.
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
          in config: action, **remainder then process_config action
          in build_minimum: true, **remainder then process_build :build_minimum, options
          in build:, **remainder then process_build :build_maximum, options
          in version:, **remainder then puts version
          in help:, **remainder then usage
          else usage
        end
      end

      private

      attr_reader :parser, :processors, :exceptions

      def parse arguments = []
        parser.call arguments
      rescue StandardError => error
        puts error.message
      end

      def process_config action
        processors.fetch(:config).call action
      end

      def process_build kind, settings
        processors.fetch(kind).call settings.rekey(build: :project_name).merge(now: Time.now)
      end

      def options
        parser.to_h
      end

      def usage
        puts parser.to_s
      end
    end
  end
end
