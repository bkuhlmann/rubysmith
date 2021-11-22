# frozen_string_literal: true

require "tocer"

module Rubysmith
  module Builders
    module Documentation
      # Builds project skeleton README documentation.
      class Readme
        def self.call(...) = new(...).call

        def initialize configuration, builder: Builder, tocer: Tocer::Writer.new
          @configuration = configuration
          @builder = builder
          @tocer = tocer
        end

        def call
          return unless configuration.build_readme

          private_methods.sort.grep(/render_/).each { |method| __send__ method }
        end

        private

        attr_reader :configuration, :builder, :tocer

        def render_content
          builder.call(configuration.with(template_path: "%project_name%/README.#{kind}.erb"))
                 .render
                 .replace("\n\n\n", "\n\n")
                 .replace("\n\n\n\n\n", "\n\n")
        end

        def render_table_of_contents
          configuration.project_root
                       .join("README.md")
                       .then { |path| tocer.call path if path.exist? }
        end

        def kind = configuration.documentation_format
      end
    end
  end
end
