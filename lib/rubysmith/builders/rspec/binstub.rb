# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module RSpec
      # Builds RSpec binstub for project skeleton.
      class Binstub < Abstract
        using Refinements::Struct

        def call
          return settings unless settings.build_rspec

          builder.call(settings.merge(template_path: "%project_name%/bin/rspec.erb"))
                 .render
                 .permit 0o755

          settings
        end
      end
    end
  end
end
