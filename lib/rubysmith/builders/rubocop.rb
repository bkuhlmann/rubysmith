# frozen_string_literal: true

require "rubocop"
require "stringio"

module Rubysmith
  module Builders
    # Builds project skeleton Rubocop code quality support.
    class Rubocop
      def self.call realm, builder: Builder
        new(realm, builder: builder).call
      end

      def initialize realm, builder: Builder, runner: RuboCop::CLI.new
        @realm = realm
        @builder = builder
        @runner = runner
      end

      def call
        return unless realm.build_rubocop

        builder.call(realm.with(template_path: "%project_name%/bin/rubocop.erb"))
               .render
               .permit 0o755

        builder.call(realm.with(template_path: "%project_name%/.rubocop.yml.erb")).render
        auto_correct
      end

      private

      attr_reader :realm, :builder, :runner

      def auto_correct
        backup = $stdout
        $stdout = StringIO.new
        runner.run ["--auto-correct", "--format", "quiet", realm.project_root.to_s]
        $stdout = backup
      end
    end
  end
end
