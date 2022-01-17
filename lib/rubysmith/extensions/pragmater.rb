# frozen_string_literal: true

require "pragmater"
require "refinements/structs"

module Rubysmith
  module Extensions
    # Ensures project skeleton has pragmas.
    class Pragmater
      using Refinements::Structs

      def self.call(...) = new(...).call

      def initialize configuration,
                     client: ::Pragmater::Runner.new,
                     content: ::Pragmater::Configuration::Content.new
        @configuration = configuration
        @client = client
        @content = content
      end

      def call = client.call(settings) && configuration

      private

      attr_reader :configuration, :client, :content

      def settings
        content.merge(action_insert: true, root_dir: configuration.project_root)
               .transmute! configuration,
                           comments: :extensions_pragmater_comments,
                           includes: :extensions_pragmater_includes
      end
    end
  end
end
