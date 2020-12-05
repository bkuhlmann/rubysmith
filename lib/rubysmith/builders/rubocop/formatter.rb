# frozen_string_literal: true

require "rubocop"
require "refinements/ios"

module Rubysmith
  module Builders
    module Rubocop
      # Executes Rubocop auto-correct on newly generated project.
      class Formatter
        using Refinements::IOs

        def self.call realm
          new(realm).call
        end

        def initialize realm, client: RuboCop::CLI.new
          @realm = realm
          @client = client
        end

        def call
          STDOUT.squelch { client.run ["--auto-correct", realm.project_root.to_s] }
          nil
        end

        private

        attr_reader :realm, :client
      end
    end
  end
end
