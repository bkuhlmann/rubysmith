# frozen_string_literal: true

require "pathname"
require "refinements/struct"

module Rubysmith
  module Builders
    # Initializes building of project by checking for existence first.
    class Init < Abstract
      using Refinements::Struct

      def call
        builder.call(configuration.merge(template_path: "%project_name%")).check
        configuration
      end
    end
  end
end
