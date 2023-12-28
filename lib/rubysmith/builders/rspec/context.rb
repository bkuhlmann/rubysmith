# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module RSpec
      # Builds RSpec shared context for temporary directories.
      class Context
        using Refinements::Struct

        def self.call(...) = new(...).call

        def initialize configuration, builder: Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          return configuration unless configuration.build_rspec

          template = "%project_name%/spec/support/shared_contexts/temp_dir.rb.erb"
          configuration.merge(template_path: template)
                       .then { |updated_configuration| builder.call updated_configuration }
                       .render
                       .replace(/\n\s+\n\s+/, "\n  ")

          configuration
        end

        private

        attr_reader :configuration, :builder
      end
    end
  end
end
