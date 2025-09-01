# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module RSpec
      # Builds RSpec spec helper for project skeleton.
      class Helper < Abstract
        using Refinements::Struct

        def call
          return false unless settings.build_rspec

          builder.call(settings.with(template_path: "%project_name%/spec/spec_helper.rb.erb"))
                 .render
                 .replace(/\A\n/, "")
                 .replace("\n\n\n", "\n\n")
                 .replace("\n  \n", "\n")

          true
        end
      end
    end
  end
end
