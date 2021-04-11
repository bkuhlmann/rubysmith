# frozen_string_literal: true

module Rubysmith
  module CLI
    module Parsers
      # Assembles and parses all Command Line Interface (CLI) options.
      class Assembler
        SECTIONS = [Core, Build].freeze # Order is important.

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
