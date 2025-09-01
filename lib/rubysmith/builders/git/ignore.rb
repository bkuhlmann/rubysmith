# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module Git
      # Builds Git repository directory and file ignore configuration.
      class Ignore < Abstract
        using Refinements::Struct

        def call
          return false unless settings.build_git

          builder.call(settings.with(template_path: "%project_name%/.gitignore.erb"))
                 .render
                 .replace("  ", "")

          true
        end
      end
    end
  end
end
