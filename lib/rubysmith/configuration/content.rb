# frozen_string_literal: true

require "pathname"
require "refinements/strings"

module Rubysmith
  module Configuration
    # Defines the common configuration content for use throughout the gem.
    Content = Struct.new(
      :action_build,
      :action_config,
      :action_help,
      :action_version,
      :author_email,
      :author_family_name,
      :author_given_name,
      :author_url,
      :build_amazing_print,
      :build_bundler_leak,
      :build_changes,
      :build_circle_ci,
      :build_citation,
      :build_community,
      :build_conduct,
      :build_console,
      :build_contributions,
      :build_dead_end,
      :build_debug,
      :build_git,
      :build_git_hub,
      :build_git_lint,
      :build_guard,
      :build_license,
      :build_maximum,
      :build_minimum,
      :build_rake,
      :build_readme,
      :build_reek,
      :build_refinements,
      :build_rspec,
      :build_rubocop,
      :build_setup,
      :build_simple_cov,
      :build_zeitwerk,
      :citation_affiliation,
      :citation_message,
      :citation_orcid,
      :community_url,
      :documentation_format,
      :documentation_url,
      :extensions_pragmater_comments,
      :extensions_pragmater_includes,
      :git_hub_user,
      :license_label,
      :license_name,
      :license_version,
      :now,
      :project_name,
      :project_version,
      :target_root,
      :template_path,
      :template_root,
      :version,
      keyword_init: true
    ) do
      using Refinements::Strings
      using Refinements::Arrays

      def initialize *arguments
        super

        self[:template_root] ||= Pathname(__dir__).join("../templates").expand_path
        self[:target_root] ||= Pathname.pwd
      end

      def with(attributes) = self.class.new(to_h.merge(attributes))

      def maximize = update_build_options(true)

      def minimize = update_build_options(false)

      def author_name = [author_given_name, author_family_name].compress.join(" ")

      def license_label_version = [license_label, license_version].compress.join("-")

      def project_label = project_name.titleize

      def project_class = project_name.camelcase

      def project_root = target_root.join(project_name)

      def project_path = project_name.snakecase

      def ascii_doc? = documentation_format == "adoc"

      def markdown? = documentation_format == "md"

      def to_pathway
        Pathway[start_root: template_root, start_path: template_path, end_root: target_root]
      end

      private

      def update_build_options value
        to_h.select { |key, _value| key.start_with? "build_" }
            .each { |key, _value| self[key] = value }
            .tap { self[:build_minimum] = !value }
            .then { self }
      end
    end
  end
end
