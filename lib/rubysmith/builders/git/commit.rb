# frozen_string_literal: true

module Rubysmith
  module Builders
    module Git
      # Builds project skeleton initial Git commit message.
      class Commit < Abstract
        include Import[:specification]

        def initialize(configuration, builder: Builder, **)
          super
        end

        def call
          return configuration unless configuration.build_git

          builder.call(configuration)
                 .run("git add .", chdir: project_name)
                 .run(
                   %(git commit --all --message "Added project skeleton" --message "#{body}"),
                   chdir: project_name
                 )

          configuration
        end

        private

        def body
          "Generated with link:#{specification.homepage_url}[#{specification.label}] " \
          "#{specification.version}."
        end

        def project_name = configuration.project_name
      end
    end
  end
end
