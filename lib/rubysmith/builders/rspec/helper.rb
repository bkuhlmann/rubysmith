# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module RSpec
      # Builds RSpec spec helper for project skeleton.
      class Helper < Abstract
        using Refinements::Struct

        def call
          return configuration unless configuration.build_rspec

          builder.call(configuration.merge(template_path: "%project_name%/spec/spec_helper.rb.erb"))
                 .render
                 .replace(/\A\n/, "")
                 .replace("\n\n\n", "\n\n")

          configuration
        end
      end
    end
  end
end
