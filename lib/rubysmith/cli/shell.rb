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
        build: Processors::Build.new
      }.freeze

      def initialize parser: Parsers::Assembler.new, processors: PROCESSORS
        @parser = parser
        @processors = processors
      end

      def call arguments = []
        parse arguments

        case options
          in config: action, **remainder then config action
          in build:, **remainder then build options.rekey(build: :project_name).merge now: Time.now
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

      def config action
        processors.fetch(__method__).call action
      end

      def build settings
        processors.fetch(__method__).call settings
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
