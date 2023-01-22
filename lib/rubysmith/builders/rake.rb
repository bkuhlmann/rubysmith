# frozen_string_literal: true

require "refinements/structs"

module Rubysmith
  module Builders
    # Builds project skeleton Rake support.
    class Rake
      using Refinements::Structs

      def self.call(...) = new(...).call

      def initialize configuration, builder: Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        return configuration unless configuration.build_rake

        add_binstub
        add_configuration
        configuration
      end

      private

      attr_reader :configuration, :builder

      def add_binstub
        builder.call(configuration.merge(template_path: "%project_name%/bin/rake.erb"))
               .render
               .permit 0o755
      end

      def add_configuration
        builder.call(configuration.merge(template_path: "%project_name%/Rakefile.erb"))
               .render
               .replace(/\[\s+/, "[")
               .replace(/\s+\]/, "]")
               .replace("  ", "")
               .replace("task.", "  task.")
               .replace(/\n+(?=require)/, "\n")
               .replace(/\n{2,}/, "\n\n")
      end
    end
  end
end
