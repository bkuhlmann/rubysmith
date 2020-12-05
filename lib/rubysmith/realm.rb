# frozen_string_literal: true

require "pathname"
require "refinements/strings"

module Rubysmith
  REALM_KEYS = %i[
    config
    template_root
    template_path
    build_root
    project_name
    author_name
    author_email
    author_url
    now
    documentation_format
    documentation_license
    build_minimum
    build_amazing_print
    build_bundler_audit
    build_bundler_leak
    build_console
    build_documentation
    build_git
    build_git_lint
    build_guard
    build_pry
    build_reek
    build_rspec
    build_rubocop
    build_setup
    build_simple_cov
    builders_pragmater_comments
    builders_pragmater_includes
    version
    help
  ].freeze

  # Represents the common context in which all builders and templates operate in.
  Realm = Struct.new(*REALM_KEYS, keyword_init: true) do
    using Refinements::Strings

    def initialize *arguments
      super

      self[:template_root] ||= Pathname(__dir__).join("templates").expand_path
      self[:build_root] ||= Pathname.pwd
      freeze
    end

    def with attributes
      self.class.new to_h.merge(attributes)
    end

    def project_label
      project_name.titleize
    end

    def project_class
      project_name.camelcase
    end

    def project_root
      build_root.join project_name
    end

    def to_pathway
      Pathway[start_root: template_root, start_path: template_path, end_root: build_root]
    end
  end
end
