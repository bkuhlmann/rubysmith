# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module Git
      # Initializes project skeleton with Git Safe support.
      class Safe < Abstract
        using Refinements::Struct

        def call
          return configuration unless configuration.build_git

          builder.call(configuration.merge(template_path: "%project_name%/.git/safe")).make_path
          configuration
        end
      end
    end
  end
end
