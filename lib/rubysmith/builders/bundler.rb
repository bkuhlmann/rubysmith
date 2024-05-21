# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    # Builds Bundler Gemfile configuration for project skeleton.
    class Bundler < Abstract
      using Refinements::Struct

      def call
        builder.call(configuration.merge(template_path: "%project_name%/Gemfile.erb"))
               .render
               .replace(/\n\s+group/, "\n\ngroup")
               .replace(/\n\s+gem/, "\n  gem")
               .replace(/  (?=.+(refinements|zeitwerk))/, "")
               .replace(/(\n+|\s+)end/, "\nend")
               .replace(/\n\ngroup :(quality|development|test|tools) do\nend/, "")
               .replace(/org"\n+/, "org\"\n\n")

        configuration
      end
    end
  end
end
