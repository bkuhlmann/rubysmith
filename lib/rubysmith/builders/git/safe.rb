# frozen_string_literal: true

require "refinements/structs"

module Rubysmith
  module Builders
    module Git
      # Initializes project skeleton with Git Safe support.
      class Safe
        using Refinements::Structs

        def self.call(...) = new(...).call

        def initialize configuration, builder: Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          return configuration unless configuration.build_git

          builder.call(configuration.merge(template_path: "%project_name%/.git/safe")).make_path
          configuration
        end

        private

        attr_reader :configuration, :builder
      end
    end
  end
end
