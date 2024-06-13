# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module Rake
      # Builds project skeleton Rake file configuration.
      class Configuration < Abstract
        using Refinements::Struct

        def call
          return false unless settings.build_rake

          builder.call(settings.merge(template_path: "%project_name%/Rakefile.erb"))
                 .render
                 .replace(/\[\s+/, "[")
                 .replace(/\s+\]/, "]")
                 .replace("  ", "")
                 .replace("task.options", "  task.options")
                 .replace(/\n+(?=require)/, "\n")
                 .replace(/\n{2,}/, "\n\n")

          true
        end
      end
    end
  end
end
