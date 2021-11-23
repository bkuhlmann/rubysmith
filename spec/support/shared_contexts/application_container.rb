# frozen_string_literal: true

require "dry/container/stub"

RSpec.shared_context "with application container" do
  using Refinements::Structs

  include_context "with temporary directory"

  let(:container) { Rubysmith::Container }

  let :configuration do
    Rubysmith::Configuration::Loader.with_defaults.call.merge(
      author_email: "jill@example.com",
      author_family_name: "Smith",
      author_given_name: "Jill",
      author_url: "https://www.jillsmith.com",
      citation_affiliation: "ACME",
      citation_orcid: "0000-1111-2222-3333",
      community_url: "https://www.example.com/community",
      documentation_url: "https://example.com/projects",
      git_hub_user: "hubber",
      now: Time.local(2020, 1, 1, 0, 0, 0),
      project_name: "test",
      target_root: temp_dir,
      template_root: Bundler.root.join("lib/rubysmith/templates"),
      version: Rubysmith::Identity::VERSION_LABEL
    )
  end

  let(:kernel) { class_spy Kernel }

  before do
    container.enable_stubs!
    container.stub :configuration, configuration
    container.stub :kernel, kernel
  end

  after do
    container.unstub :configuration
    container.unstub :kernel
  end
end
