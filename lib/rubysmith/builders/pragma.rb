# frozen_string_literal: true

require "pragmater"

module Rubysmith
  module Builders
    # Builds project skeleton pragmas so all Ruby strings are frozen by default.
    class Pragma
      def self.call(realm) = new(realm).call

      def initialize realm, client: Pragmater::Runner
        @realm = realm
        @client = client
      end

      def call = client.for(**attributes).call && nil

      private

      attr_reader :realm, :client

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
