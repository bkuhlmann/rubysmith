# frozen_string_literal: true

require "bundler"
require "bundler/cli"

module Rubysmith
  module Builders
    # Builds Bundler Gemfile configuration and installs gem dependencies for project skeleton.
    class Bundler
      def self.call realm, builder: Builder
        new(realm, builder: builder).call
      end

      def initialize realm, builder: Builder, runner: ::Bundler::CLI
        @realm = realm
        @builder = builder
        @runner = runner
      end

      def call
        builder.call(realm.with(template_path: "%project_name%/Gemfile.erb"))
               .render
               .replace(/\n\s*group/, "\n\ngroup")
               .replace(/\n\s*gem/, "\n  gem")
               .replace(/\s{4}\n/, "")
               .replace("  end", "end")
               .replace(/\n{1,}\Z/, "\n")
               .replace(/\n\ngroup :(code_quality|test) do\nend/, "")
        Dir.chdir(realm.project_root) { runner.start %w[install --quiet] }
        nil
      end

      private

      attr_reader :realm, :builder, :runner
    end
  end
end
