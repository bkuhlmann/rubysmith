# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module GitHub
      # Builds project skeleton GitHub funding template.
      class Funding < Abstract
        using Refinements::Struct

        def call
          return false unless settings.build_git_hub && settings.build_funding

          settings.merge(template_path: "%project_name%/.github/FUNDING.yml.erb")
                  .then { |updated_configuration| builder.call(updated_configuration).render }

          true
        end
      end
    end
  end
end
