# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module RSpec
      # Builds RSpec shared context for temporary directories.
      class Context < Abstract
        using Refinements::Struct

        def call
          return configuration unless configuration.build_rspec

          template = "%project_name%/spec/support/shared_contexts/temp_dir.rb.erb"
          configuration.merge(template_path: template)
                       .then { |updated_configuration| builder.call updated_configuration }
                       .render
                       .replace(/\n\s+\n\s+/, "\n  ")

          configuration
        end
      end
    end
  end
end
