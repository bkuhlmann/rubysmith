# frozen_string_literal: true

require "pathname"
require "refinements/strings"

module Rubysmith
  module CLI
    module Configuration
      # Defines the common configuration content for use throughout the gem.
      Content = Struct.new(
        :action_build,
        :action_config,
        :action_help,
        :action_version,
        :author_email,
        :author_name,
        :author_url,
        :build_amazing_print,
        :build_bundler_leak,
        :build_console,
        :build_debug,
        :build_documentation,
        :build_git,
        :build_git_lint,
        :build_guard,
        :build_minimum,
        :build_rake,
        :build_reek,
        :build_refinements,
        :build_rspec,
        :build_rubocop,
        :build_setup,
        :build_simple_cov,
        :build_zeitwerk,
        :builders_pragmater_comments,
        :builders_pragmater_includes,
        :documentation_format,
        :documentation_license,
        :now,
        :project_name,
        :target_root,
        :template_path,
        :template_root,
        keyword_init: true
      ) do
        using Refinements::Strings

        def initialize *arguments
          super

          self[:template_root] ||= Pathname(__dir__).join("../../templates").expand_path
          self[:target_root] ||= Pathname.pwd
        end

        def with(attributes) = self.class.new(to_h.merge(attributes))

        def minimize
          to_h.except(:build_minimum)
              .select { |key, _value| key.start_with? "build_" }
              .each { |key, _value| self[key] = false }
              .then { self }
        end

        def project_label = project_name.titleize

        def project_class = project_name.camelcase

        def project_root = target_root.join(project_name)

        def project_path = project_name.snakecase

        def to_pathway
          Pathway[start_root: template_root, start_path: template_path, end_root: target_root]
        end
      end
    end
  end
end
