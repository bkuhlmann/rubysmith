# frozen_string_literal: true

module Rubysmith
  module CLI
    # The main Command Line Interface (CLI) object.
    class Shell
      PROCESSORS = {
        config: Processors::Config.new,
        build_minimum: Processors::Build.with_minimum,
        build_maximum: Processors::Build.new
      }.freeze

      def initialize parser: Parsers::Assembler.new, processors: PROCESSORS, container: Container
        @parser = parser
        @processors = processors
        @container = container
      end

      def call arguments = []
        case parse arguments
          in config: Symbol => action then process_config action
          in build_minimum: true then process_build :build_minimum
          in build_any: true then process_build :build_maximum
          in version: String => version then puts version
          else usage
        end
      end

      private

      attr_reader :parser, :processors, :container

      def parse arguments = []
        parser.call arguments
      rescue StandardError => error
        puts error.message
      end

      def process_config(action) = processors.fetch(:config).call(action)

      def process_build(kind) = processors.fetch(kind).call

      def usage = logger.unknown(parser.to_s)

      def logger = container[__method__]
    end
  end
end
