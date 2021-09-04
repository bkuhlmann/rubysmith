# frozen_string_literal: true

module Rubysmith
  module Builders
    module Git
      # Builds project skeleton initial Git commit message.
      class Commit
        def self.call(...) = new(...).call

        def initialize configuration, builder: Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          return unless configuration.build_git

          builder.call(configuration)
                 .run("git add .", chdir: project_name)
                 .run(
                   %(git commit --all --message "Added project skeleton" --message "#{body}"),
                   chdir: project_name
                 )
        end

        private

        attr_reader :configuration, :builder

        def body
          <<~CONTENT
            Generated with [#{Identity::LABEL}]("https://www.alchemists.io/projects/rubysmith")
            #{Identity::VERSION}.
          CONTENT
        end

        def project_name = configuration.project_name
      end
    end
  end
end
