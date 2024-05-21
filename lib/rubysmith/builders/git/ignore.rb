# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module Git
      # Builds Git repository directory and file ignore configuration.
      class Ignore < Abstract
        using Refinements::Struct

        def call
          return configuration unless configuration.build_git

          builder.call(configuration.merge(template_path: "%project_name%/.gitignore.erb"))
                 .render
                 .replace("  ", "")

          configuration
        end
      end
    end
  end
end
