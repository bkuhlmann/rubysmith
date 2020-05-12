# frozen_string_literal: true

require "pragmater"

module Rubysmith
  module Builders
    # Builds project skeleton pragmas so all Ruby strings are frozen by default.
    class Pragma
      def self.call realm
        new(realm).call
      end

      def initialize realm, runner: Pragmater::Runner
        @realm = realm
        @runner = runner
      end

      def call
        runner.for(**attributes).call
        nil
      end

      private

      attr_reader :realm, :runner

      def attributes
        {
          action: :insert,
          root_dir: realm.project_root,
          comments: realm.builders_pragmater_comments,
          includes: realm.builders_pragmater_includes
        }
      end
    end
  end
end
