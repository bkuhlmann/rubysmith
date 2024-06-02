# frozen_string_literal: true

require "erb"

module Rubysmith
  module Renderers
    # Renders ERB templates as fully functional files.
    class ERB
      def initialize settings,
                     scope: Renderers::Namespace.new(settings.project_namespaced_class),
                     client: ::ERB
        @settings = settings
        @scope = scope
        @client = client
      end

      def call(content) = client.new(content, trim_mode: "<>", eoutvar: "@buffer").result(binding)

      private

      attr_accessor :buffer
      attr_reader :settings, :scope, :client

      def namespace
        source = buffer.dup

        self.buffer = source + if block_given?
                                 scope.call yield.sub(source, "")
                               else
                                 scope.call
                               end
      end
    end
  end
end
