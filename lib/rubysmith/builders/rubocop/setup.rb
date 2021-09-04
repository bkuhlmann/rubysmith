# frozen_string_literal: true

module Rubysmith
  module Builders
    module Rubocop
      # Builds project skeleton for Rubocop code quality support.
      class Setup
        def self.call(...) = new(...).call

        def initialize configuration, builder: Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          return unless configuration.build_rubocop

          builder.call(configuration.with(template_path: "%project_name%/bin/rubocop.erb"))
                 .render
                 .permit 0o755

          builder.call(configuration.with(template_path: "%project_name%/.rubocop.yml.erb")).render
        end

        private

        attr_reader :configuration, :builder
      end
    end
  end
end
