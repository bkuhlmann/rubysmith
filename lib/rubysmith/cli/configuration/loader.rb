# frozen_string_literal: true

require "pathname"
require "refinements/hashes"
require "refinements/structs"
require "runcom"
require "yaml"

module Rubysmith
  module CLI
    module Configuration
      # Represents the fully assembled Command Line Interface (CLI) configuration.
      class Loader
        using Refinements::Hashes
        using Refinements::Structs

        DEFAULTS = YAML.load_file(Pathname(__dir__).join("defaults.yml")).freeze
        CLIENT = Runcom::Config.new "#{Identity::NAME}/configuration.yml", defaults: DEFAULTS

        ENHANCERS = [
          Enhancers::GitHubUser.new,
          Enhancers::CurrentTime.new,
          Enhancers::Version.new
        ].freeze

        def self.call(...) = new(...).call

        def self.with_defaults = new(client: DEFAULTS, enhancers: [])

        def initialize content: Content.new, client: CLIENT, enhancers: ENHANCERS
          @content = content
          @client = client
          @enhancers = enhancers
        end

        def call = enhancers.reduce(preload_content) { |preload, enhancer| enhancer.call preload }

        private

        attr_reader :content, :client, :enhancers

        def preload_content = content.merge(**client.to_h.flatten_keys)
      end
    end
  end
end
