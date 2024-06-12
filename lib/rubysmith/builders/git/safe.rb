# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module Git
      # Initializes project skeleton with Git Safe support.
      class Safe < Abstract
        using Refinements::Struct

        def call
          return false unless settings.build_git

          builder.call(settings.merge(template_path: "%project_name%/.git/safe")).make_path
          true
        end
      end
    end
  end
end
