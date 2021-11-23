# frozen_string_literal: true

module Rubysmith
  module Builders
    module RSpec
      # Builds RSpec spec helper for project skeleton.
      class Helper
        def self.call(...) = new(...).call

        def initialize configuration, builder: Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          return configuration unless configuration.build_rspec

          builder.call(configuration.with(template_path: "%project_name%/spec/spec_helper.rb.erb"))
                 .render
                 .replace(/\n{3,}/, "\n\n")
                 .replace(/\n\s{2}(?=(require|Simple|using|Pathname|Dir))/, "\n")

          configuration
        end

        private

        attr_reader :configuration, :builder
      end
    end
  end
end
