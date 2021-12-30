# frozen_string_literal: true

require "pathname"
require "refinements/arrays"
require "refinements/strings"
require "refinements/structs"

module Rubysmith
  # rubocop:disable Metrics/ModuleLength
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
      :build_cli,
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
      :build_security,
      :build_setup,
      :build_simple_cov,
      :build_zeitwerk,
      :citation_affiliation,
      :citation_message,
      :citation_orcid,
      :documentation_format,
      :extensions_milestoner_documentation_format,
      :extensions_milestoner_prefixes,
      :extensions_milestoner_sign,
      :extensions_pragmater_comments,
      :extensions_pragmater_includes,
      :extensions_tocer_includes,
      :extensions_tocer_label,
      :git_hub_user,
      :license_label,
      :license_name,
      :license_version,
      :now,
      :project_name,
      :project_url_changes,
      :project_url_community,
      :project_url_documentation,
      :project_url_download,
      :project_url_issues,
      :project_url_source,
      :project_version,
      :target_root,
      :template_path,
      :template_roots,
      keyword_init: true
    ) do
      using Refinements::Arrays
      using Refinements::Strings
      using Refinements::Structs

      def initialize *arguments
        super

        self[:template_roots] ||= [Pathname(__dir__).join("../templates")]
        self[:target_root] ||= Pathname.pwd
        freeze
      end

      def add_template_roots paths
        Array(paths).map { |path| Pathname path }
                    .including(template_roots)
                    .then { |roots| dup.merge! template_roots: roots }
      end

      def with(attributes) = dup.merge!(**attributes).freeze

      def maximize = update_build_options(true)

      def minimize = update_build_options(false)

      def author_name = [author_given_name, author_family_name].compress.join(" ")

      def license_label_version = [license_label, license_version].compress.join("-")

      def project_label = project_name.titleize

      def project_class = project_name.camelcase

      def project_root = target_root.join(project_name)

      def project_path = project_name.snakecase

      def computed_project_url_changes = format_url(__method__)

      def computed_project_url_community = format_url(__method__)

      def computed_project_url_documentation = format_url(__method__)

      def computed_project_url_download = format_url(__method__)

      def computed_project_url_issues = format_url(__method__)

      def computed_project_url_source = format_url(__method__)

      def ascii_doc? = documentation_format == "adoc"

      def markdown? = documentation_format == "md"

      def pathway
        Pathway[start_root: template_root, start_path: template_path, end_root: target_root]
      end

      def template_root
        template_roots.map(&:expand_path)
                      .find { |path| path.join(String(template_path)).exist? }
      end

      private

      def format_url kind
        kind.to_s
            .sub("computed_", "")
            .then { |method| public_send method }
            .then { |url| String url }
            .then { |url| url.sub "%project_name%", project_name }
      end

      def update_build_options value
        to_h.select { |key, _value| key.start_with? "build_" }
            .transform_values { value }
            .then { |attributes| dup.merge!(**attributes, build_minimum: !value) }
            .freeze
      end
    end
  end
  # rubocop:enable Metrics/ModuleLength
end
