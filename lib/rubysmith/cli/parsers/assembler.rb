# frozen_string_literal: true

module Rubysmith
  module CLI
    module Parsers
      # Assembles and parses all Command Line Interface (CLI) options.
      class Assembler
        SECTIONS = [Core, Build].freeze # Order is important.

        def initialize sections: SECTIONS, client: CLIENT, container: Container
          @sections = sections
          @client = client
          @container = container
        end

        def call arguments = []
          sections.each { |parser| parser.call client: client }
          client.parse! arguments
          configuration
        end

        def to_s = client.to_s

        private

        attr_reader :sections, :client, :container

        def configuration = container[__method__]
      end
    end
  end
end
