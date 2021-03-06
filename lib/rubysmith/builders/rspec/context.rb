# frozen_string_literal: true

module Rubysmith
  module Builders
    module RSpec
      # Builds RSpec shared context for temporary directories.
      class Context
        def self.call(configuration, builder: Builder) = new(configuration, builder: builder).call

        def initialize configuration, builder: Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          return unless configuration.build_rspec

          template = "%project_name%/spec/support/shared_contexts/temp_dir.rb.erb"
          configuration.with(template_path: template)
                       .then { |updated_configuration| builder.call updated_configuration }
                       .render
                       .replace(/\n\s+\n\s+/, "\n  ")
        end

        private

        attr_reader :configuration, :builder
      end
    end
  end
end
