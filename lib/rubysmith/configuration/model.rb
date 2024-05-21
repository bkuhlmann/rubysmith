# frozen_string_literal: true

require "pathname"
require "refinements/array"
require "refinements/string"
require "refinements/struct"

module Rubysmith
  module Configuration
    # Defines the common configuration content for use throughout the gem.
    Model = Struct.new(
      :author_email,
      :author_family_name,
      :author_given_name,
      :author_url,
      :build_amazing_print,
      :build_caliber,
      :build_circle_ci,
      :build_citation,
      :build_cli,
      :build_community,
      :build_conduct,
      :build_console,
      :build_contributions,
      :build_debug,
      :build_funding,
      :build_git,
      :build_git_hub,
      :build_git_hub_ci,
      :build_git_lint,
      :build_guard,
      :build_irb_kit,
      :build_license,
      :build_maximum,
      :build_minimum,
      :build_rake,
      :build_readme,
      :build_reek,
      :build_refinements,
      :build_rspec,
      :build_rtc,
      :build_security,
      :build_setup,
      :build_simple_cov,
      :build_versions,
      :build_zeitwerk,
      :citation_affiliation,
      :citation_message,
      :citation_orcid,
      :documentation_format,
      :git_hub_user,
      :license_label,
      :license_name,
      :license_version,
      :now,
      :project_name,
      :project_url_community,
      :project_url_conduct,
      :project_url_contributions,
      :project_url_download,
      :project_url_funding,
      :project_url_home,
      :project_url_issues,
      :project_url_license,
      :project_url_security,
      :project_url_source,
      :project_url_versions,
      :project_version,
      :target_root,
      :template_path,
      :template_roots
    ) do
      using Refinements::Array
      using Refinements::String
      using Refinements::Struct

      def maximize = update_build_options true

      def minimize = update_build_options false

      def author_name = [author_given_name, author_family_name].compress.join(" ")

      def license_label_version = [license_label, license_version].compress.join("-")

      def project_class = project_namespaced_class.split("::").last

      def project_namespaced_class = project_name.camelcase

      def project_label = project_name.titleize

      def project_levels = project_namespaced_class.split("::").size - 1

      def project_path = project_name.snakecase

      def project_root = target_root.join(project_name)

      def computed_project_url_community = format_url(__method__)

      def computed_project_url_conduct = format_url(__method__)

      def computed_project_url_contributions = format_url(__method__)

      def computed_project_url_download = format_url(__method__)

      def computed_project_url_funding = format_url(__method__)

      def computed_project_url_home = format_url(__method__)

      def computed_project_url_issues = format_url(__method__)

      def computed_project_url_license = format_url(__method__)

      def computed_project_url_security = format_url(__method__)

      def computed_project_url_source = format_url(__method__)

      def computed_project_url_versions = format_url(__method__)

      def ascii_doc? = documentation_format == "adoc"

      def markdown? = documentation_format == "md"

      def pathway
        Pathway[start_root: template_root, start_path: template_path, end_root: target_root]
      end

      def template_root
        Array(template_roots).map(&:expand_path)
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
end
