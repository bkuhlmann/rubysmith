# frozen_string_literal: true

require "pathname"
require "refinements/hashes"
require "refinements/structs"
require "runcom"
require "yaml"

module Rubysmith
  module Configuration
    # Represents the fully assembled Command Line Interface (CLI) configuration.
    class Loader
      using Refinements::Hashes
      using Refinements::Structs

      DEFAULTS = YAML.load_file(Pathname(__dir__).join("defaults.yml")).freeze
      CLIENT = Runcom::Config.new "rubysmith/configuration.yml", defaults: DEFAULTS

      def self.call(...) = new(...).call

      def self.with_defaults = new(client: DEFAULTS, enhancers: {})

      def initialize model: Model.new, client: CLIENT, enhancers: Enhancers::Container
        @model = model
        @client = client
        @enhancers = enhancers
      end

      def call
        enhancers.each
                 .reduce(preload_content) { |preload, (_key, enhancer)| enhancer.call preload }
                 .freeze
      end

      protected

      attr_reader :model, :client, :enhancers

      private

      def preload_content = model.merge(**client.to_h.flatten_keys)
    end
  end
end
