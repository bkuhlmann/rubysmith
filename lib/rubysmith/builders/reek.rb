# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    # Builds project skeleton Reek code quality support.
    class Reek < Abstract
      using Refinements::Struct

      def call
        return configuration unless configuration.build_reek

        builder.call(configuration.merge(template_path: "%project_name%/.reek.yml.erb")).render
        configuration
      end
    end
  end
end
