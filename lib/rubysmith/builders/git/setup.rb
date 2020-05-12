# frozen_string_literal: true

module Rubysmith
  module Builders
    module Git
      # Initializes project skeleton as a Git repository.
      class Setup
        def self.call realm, builder: Builder
          new(realm, builder: builder).call
        end

        def initialize realm, builder: Builder
          @realm = realm
          @builder = builder
        end

        def call
          return unless realm.build_git

          builder.call(realm).run("git init", chdir: realm.project_name)
        end

        private

        attr_reader :realm, :builder
      end
    end
  end
end
