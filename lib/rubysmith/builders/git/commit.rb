# frozen_string_literal: true

module Rubysmith
  module Builders
    module Git
      # Builds project skeleton initial Git commit message.
      class Commit
        def self.call(realm, builder: Builder) = new(realm, builder: builder).call

        def initialize realm, builder: Builder
          @realm = realm
          @builder = builder
        end

        def call
          return unless realm.build_git

          builder.call(realm)
                 .run("git add .", chdir: project_name)
                 .run(
                   %(git commit --all --message "Added project skeleton" --message "#{body}"),
                   chdir: project_name
                 )
        end

        private

        attr_reader :realm, :builder

        def body
          <<~CONTENT
            Generated with [#{Identity::LABEL}]("https://www.alchemists.io/projects/rubysmith")
            #{Identity::VERSION}.
          CONTENT
        end

        def project_name = realm.project_name
      end
    end
  end
end
