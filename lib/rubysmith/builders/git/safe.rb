# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module Git
      # Initializes project skeleton with Git Safe support.
      class Safe < Abstract
        using Refinements::Struct

        def call
          return settings unless settings.build_git

          builder.call(settings.merge(template_path: "%project_name%/.git/safe")).make_path
          settings
        end
      end
    end
  end
end
