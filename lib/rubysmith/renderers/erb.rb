# frozen_string_literal: true

require "erb"

module Rubysmith
  module Renderers
    # Renders ERB templates as fully functional files.
    class ERB
      def initialize realm, scope: Renderers::Namespace.new(realm.project_class), client: ::ERB
        @realm = realm
        @scope = scope
        @client = client
      end

      def call content
        client.new(content, trim_mode: "<>", eoutvar: "@buffer").result binding
      end

      private

      attr_accessor :buffer
      attr_reader :realm, :scope, :client

      def namespace
        self.buffer = scope.call yield
      end
    end
  end
end
