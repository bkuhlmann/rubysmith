# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module RSpec
      # Builds RSpec binstub for project skeleton.
      class Binstub < Abstract
        using Refinements::Struct

        def call
          return false unless settings.build_rspec

          builder.call(settings.with(template_path: "%project_name%/bin/rspec.erb"))
                 .render
                 .permit 0o755

          true
        end
      end
    end
  end
end
