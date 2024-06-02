# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module Git
      # Builds Git repository directory and file ignore configuration.
      class Ignore < Abstract
        using Refinements::Struct

        def call
          return settings unless settings.build_git

          builder.call(settings.merge(template_path: "%project_name%/.gitignore.erb"))
                 .render
                 .replace("  ", "")

          settings
        end
      end
    end
  end
end
