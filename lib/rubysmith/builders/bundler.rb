# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    # Builds Bundler Gemfile configuration for project skeleton.
    class Bundler < Abstract
      using Refinements::Struct

      def call
        builder.call(settings.merge(template_path: "%project_name%/Gemfile.erb"))
               .render
               .replace(/\n\s+group/, "\n\ngroup")
               .replace(/\n\s+gem/, "\n  gem")
               .replace(/  (?=.+(bootsnap|dry-monads|refinements|zeitwerk))/, "")
               .replace(/(\n+|\s+)end/, "\nend")
               .replace(/\n\ngroup :(quality|development|test|tools) do\nend/, "")
               .replace(/org"\n+/, "org\"\n\n")

        true
      end
    end
  end
end
