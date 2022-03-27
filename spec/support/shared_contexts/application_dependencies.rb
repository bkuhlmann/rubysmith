# frozen_string_literal: true

require "dry/container/stub"
require "auto_injector/stub"

RSpec.shared_context "with application dependencies" do
  using Refinements::Structs
  using AutoInjector::Stub

  include_context "with temporary directory"

  let :configuration do
    Rubysmith::Configuration::Loader.with_defaults.call.merge(
      author_email: "jill@example.com",
      author_family_name: "Smith",
      author_given_name: "Jill",
      author_url: "https://www.jillsmith.com",
      citation_affiliation: "ACME",
      citation_orcid: "0000-1111-2222-3333",
      git_hub_user: "hubber",
      now: Time.local(2020, 1, 1, 0, 0, 0),
      project_name: "test",
      project_url_community: "https://www.example.com/%project_name%/community",
      project_url_conduct: "https://www.example.com/%project_name%/code_of_conduct",
      project_url_contributions: "https://www.example.com/%project_name%/contributions",
      project_url_download: "https://www.example.com/%project_name%/download",
      project_url_home: "https://www.example.com/%project_name%",
      project_url_issues: "https://www.example.com/%project_name%/issues",
      project_url_license: "https://www.example.com/%project_name%/license",
      project_url_security: "https://www.example.com/%project_name%/security",
      project_url_source: "https://www.example.com/%project_name%/source",
      project_url_versions: "https://www.example.com/%project_name%/versions",
      target_root: temp_dir,
      template_roots: [Bundler.root.join("lib/rubysmith/templates")]
    )
  end

  let(:kernel) { class_spy Kernel }

  let :logger do
    Cogger::Client.new Logger.new(StringIO.new),
                       formatter: ->(_severity, _name, _at, message) { "#{message}\n" }
  end

  before { Rubysmith::Import.stub configuration:, kernel:, logger: }

  after { Rubysmith::Import.unstub :configuration, :kernel, :logger }
end
