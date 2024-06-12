# frozen_string_literal: true

require "pathname"
require "refinements/struct"

module Rubysmith
  module Builders
    # Initializes building of project by checking for existence first.
    class Init < Abstract
      using Refinements::Struct

      def call
        builder.call(settings.merge(template_path: "%project_name%")).check
        true
      end
    end
  end
end
