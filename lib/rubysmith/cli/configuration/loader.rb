# frozen_string_literal: true

require "pathname"
require "refinements/hashes"
require "runcom"
require "yaml"

module Rubysmith
  module CLI
    module Configuration
      # Represents the fully assembled Command Line Interface (CLI) configuration.
      class Loader
        using Refinements::Hashes

        DEFAULTS = YAML.load_file(Pathname(__dir__).join("defaults.yml")).freeze
        CLIENT = Runcom::Config.new "#{Identity::NAME}/configuration.yml", defaults: DEFAULTS

        def initialize client: CLIENT
          @client = client
        end

        def to_h = client.to_h.flatten_keys

        private

        attr_reader :client
      end
    end
  end
end
