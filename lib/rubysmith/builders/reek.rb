# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    # Builds project skeleton Reek code quality support.
    class Reek < Abstract
      using Refinements::Struct

      def call
        return false unless settings.build_reek

        builder.call(settings.with(template_path: "%project_name%/.reek.yml.erb")).render
        true
      end
    end
  end
end
