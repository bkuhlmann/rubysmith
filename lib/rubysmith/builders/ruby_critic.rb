# frozen_string_literal: true

module Rubysmith
  module Builders
    # Builds project skeleton RubyCritic code quality support.
    class RubyCritic
      def self.call(...) = new(...).call

      def initialize configuration, builder: Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        return unless configuration.build_ruby_critic

        builder.call(configuration.with(template_path: "%project_name%/.rubycritic.yml.erb")).render
      end

      private

      attr_reader :configuration, :builder
    end
  end
end
