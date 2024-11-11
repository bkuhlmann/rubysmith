# frozen_string_literal: true

module Rubysmith
  module Builders
    module Git
      # Builds project skeleton initial Git commit message.
      class Commit < Abstract
        include Dependencies[:specification]

        def call
          return false unless settings.build_git

          builder.call(settings)
                 .run("git add .", chdir: project_name)
                 .run(
                   %(git commit --all --message "Added project skeleton" --message "#{body}"),
                   chdir: project_name
                 )

          true
        end

        private

        def body
          "Generated with link:#{specification.homepage_url}[#{specification.label}] " \
          "#{specification.version}."
        end

        def project_name = settings.project_name
      end
    end
  end
end
