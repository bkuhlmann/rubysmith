# frozen_string_literal: true

module Rubysmith
  module Builders
    module Git
      # Builds project skeleton initial Git commit message.
      class Commit
        include Import[:specification]

        def self.call(...) = new(...).call

        def initialize(configuration, builder: Builder, **)
          super(**)
          @configuration = configuration
          @builder = builder
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

        attr_reader :configuration, :builder

        def body
          "Generated with link:#{specification.homepage_url}[#{specification.label}] " \
          "#{specification.version}."
        end

        def project_name = configuration.project_name
      end
    end
  end
end
