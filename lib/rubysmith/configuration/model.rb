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
      :author_handle,
      :author_uri,
      :build_amazing_print,
      :build_bootsnap,
      :build_caliber,
      :build_circle_ci,
      :build_citation,
      :build_cli,
      :build_community,
      :build_conduct,
      :build_console,
      :build_contributions,
      :build_dcoo,
      :build_debug,
      :build_docker,
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
      :license_label,
      :license_name,
      :license_version,
      :loaded_at,
      :organization_label,
      :organization_uri,
      :project_name,
      :project_uri_community,
      :project_uri_conduct,
      :project_uri_contributions,
      :project_uri_dcoo,
      :project_uri_download,
      :project_uri_funding,
      :project_uri_home,
      :project_uri_issues,
      :project_uri_license,
      :project_uri_security,
      :project_uri_source,
      :project_uri_versions,
      :project_version,
      :repository_handle,
      :repository_uri,
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

      def computed_project_uri_community = format_uri(__method__)

      def computed_project_uri_conduct = format_uri(__method__)

      def computed_project_uri_contributions = format_uri(__method__)

      def computed_project_uri_dcoo = format_uri(__method__)

      def computed_project_uri_download = format_uri(__method__)

      def computed_project_uri_funding = format_uri(__method__)

      def computed_project_uri_home = format_uri(__method__)

      def computed_project_uri_issues = format_uri(__method__)

      def computed_project_uri_license = format_uri(__method__)

      def computed_project_uri_security = format_uri(__method__)

      def computed_project_uri_source = format_uri(__method__)

      def computed_project_uri_versions = format_uri(__method__)

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

      def format_uri kind
        kind.to_s
            .sub("computed_", "")
            .then { |method| public_send method }
            .then { |uri| String uri }
            .then { |uri| uri.sub "%<project_name>s", project_name }
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
