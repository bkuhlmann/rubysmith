# frozen_string_literal: true

require "yaml"
require "refinements/hashes"
require "runcom"

module Rubysmith
  module CLI
    # Represents the fully assembled Command Line Interface (CLI) configuration.
    class Configuration
      using Refinements::Hashes

      DEFAULTS = YAML.load_file(Pathname(__dir__).join("defaults.yml")).freeze
      CLIENT = Runcom::Config.new "#{Identity::NAME}/configuration.yml", defaults: DEFAULTS

      def initialize client: CLIENT
        @client = client
      end

      def to_h
        client.to_h.flatten_keys
      end

      private

      attr_reader :client
    end
  end
end
