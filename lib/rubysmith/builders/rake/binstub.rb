# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module Rake
      # Builds project skeleton Rake binstub.
      class Binstub < Abstract
        using Refinements::Struct

        def call
          return false unless settings.build_rake

          builder.call(settings.with(template_path: "%project_name%/bin/rake.erb"))
                 .render
                 .permit 0o755

          true
        end
      end
    end
  end
end
