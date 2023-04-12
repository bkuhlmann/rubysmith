# frozen_string_literal: true

require "core"
require "milestoner"

module Rubysmith
  module CLI
    # The main Command Line Interface (CLI) object.
    class Shell
      include Actions::Import[:config, :build, :kernel, :logger, :publish, :specification]

      def initialize(parser: Parser.new, **)
        super(**)
        @parser = parser
      end

      def call arguments = Core::EMPTY_ARRAY
        act_on parser.call(arguments)
      rescue OptionParser::ParseError, Milestoner::Error => error
        logger.error { error.message }
      end

      private

      attr_reader :parser

      def act_on configuration
        case configuration
          in action_config: Symbol => action then config.call action
          in action_build: true then build.call configuration
          in action_publish: true then publish.call configuration
          in action_version: true then kernel.puts specification.labeled_version
          else kernel.puts parser.to_s
        end
      end
    end
  end
end
