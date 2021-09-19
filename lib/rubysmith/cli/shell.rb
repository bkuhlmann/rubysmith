# frozen_string_literal: true

module Rubysmith
  module CLI
    # The main Command Line Interface (CLI) object.
    class Shell
      ACTIONS = {config: Actions::Config.new, build: Actions::Build.new}.freeze

      def initialize parser: Parsers::Assembler.new, actions: ACTIONS, container: Container
        @parser = parser
        @actions = actions
        @container = container
      end

      def call arguments = []
        case parse arguments
          in action_config: Symbol => action then config action
          in action_build: true then build
          in action_version: true then logger.info configuration.version
          else usage
        end
      end

      private

      attr_reader :parser, :actions, :container

      def parse arguments = []
        parser.call arguments
      rescue StandardError => error
        logger.error error.message
      end

      def config(action) = actions.fetch(__method__).call(action)

      def build = actions.fetch(__method__).call

      def usage = logger.unknown(parser.to_s)

      def configuration = container[__method__]

      def logger = container[__method__]
    end
  end
end
