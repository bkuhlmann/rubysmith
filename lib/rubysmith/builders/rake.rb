# frozen_string_literal: true

module Rubysmith
  module Builders
    # Builds project skeleton Rake support.
    class Rake
      def self.call(configuration, builder: Builder) = new(configuration, builder: builder).call

      def initialize configuration, builder: Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        builder.call(configuration.with(template_path: "%project_name%/Rakefile.erb"))
               .render
               .replace(/\[\s+/, "[")
               .replace(/\s+\]/, "]")
               .replace("  ", "")
               .replace(/\n+(?=require)/, "\n")
               .replace(/\n{2,}/, "\n\n")
        nil
      end

      private

      attr_reader :configuration, :builder
    end
  end
end
