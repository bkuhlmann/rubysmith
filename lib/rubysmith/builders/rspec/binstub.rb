# frozen_string_literal: true

require "refinements/structs"

module Rubysmith
  module Builders
    module RSpec
      # Builds RSpec binstub for project skeleton.
      class Binstub
        using Refinements::Structs

        def self.call(...) = new(...).call

        def initialize configuration, builder: Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          return configuration unless configuration.build_rspec

          builder.call(configuration.merge(template_path: "%project_name%/bin/rspec.erb"))
                 .render
                 .permit 0o755

          configuration
        end

        private

        attr_reader :configuration, :builder
      end
    end
  end
end
