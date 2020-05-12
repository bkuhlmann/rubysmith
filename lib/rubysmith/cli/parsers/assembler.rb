# frozen_string_literal: true

require "runcom"

module Rubysmith
  module CLI
    module Parsers
      CLIENT = OptionParser.new nil, 40, "  "
      SECTIONS = [Core, Build].freeze # Order is important.

      # Assembles and parses all Command Line Interface (CLI) options.
      class Assembler
        def initialize client = CLIENT, sections: SECTIONS, configuration: CLI::Configuration.new
          @client = client
          @sections = sections
          @options = configuration.to_h
        end

        def call arguments = []
          sections.each { |parser| parser.call client: client, options: options }
          client.parse! arguments
          options
        end

        def to_h
          options
        end

        def to_s
          client.to_s
        end

        private

        attr_reader :client, :sections, :options
      end
    end
  end
end
