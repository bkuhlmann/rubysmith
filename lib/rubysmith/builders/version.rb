# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    # Builds project skeleton Ruby version file.
    class Version < Abstract
      using Refinements::Struct

      def call
        builder.call(settings.merge(template_path: "%project_name%/.ruby-version.erb"))
               .render
               .append("\n")
        true
      end
    end
  end
end
