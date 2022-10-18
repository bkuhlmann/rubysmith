# frozen_string_literal: true

require "refinements/structs"

module Rubysmith
  module Builders
    module RSpec
      # Builds RSpec spec helper for project skeleton.
      class Helper
        using Refinements::Structs

        def self.call(...) = new(...).call

        def initialize configuration, builder: Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          return configuration unless configuration.build_rspec

          builder.call(configuration.merge(template_path: "%project_name%/spec/spec_helper.rb.erb"))
                 .render
                 .replace("\n\n\n", "\n\n")

          configuration
        end

        private

        attr_reader :configuration, :builder
      end
    end
  end
end
