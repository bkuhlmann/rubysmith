# frozen_string_literal: true

RSpec.shared_context "with application dependencies" do
  using Refinements::Struct

  include_context "with temporary directory"

  let(:settings) { Rubysmith::Container[:settings] }
  let(:logger) { Cogger.new id: :rubysmith, io: StringIO.new, level: :debug }
  let(:kernel) { class_spy Kernel }
  let(:io) { StringIO.new }

  before do
    settings.merge! Etcher.call(
      Rubysmith::Container[:registry].remove_loader(1),
      author_email: "jill@acme.io",
      author_family_name: "Smith",
      author_given_name: "Jill",
      author_url: "https://acme.io/team/jill_smith",
      git_hub_user: "jsmith",
      loaded_at: Time.utc(2020, 1, 1, 0, 0, 0),
      organization_url: "https://acme.io",
      project_name: "test",
      project_url_community: "https://acme.io/%project_name%/community",
      project_url_conduct: "https://acme.io/%project_name%/code_of_conduct",
      project_url_contributions: "https://acme.io/%project_name%/contributions",
      project_url_download: "https://acme.io/%project_name%/download",
      project_url_home: "https://acme.io/%project_name%",
      project_url_issues: "https://acme.io/%project_name%/issues",
      project_url_license: "https://acme.io/%project_name%/license",
      project_url_security: "https://acme.io/%project_name%/security",
      project_url_source: "https://acme.io/%project_name%/source",
      project_url_versions: "https://acme.io/%project_name%/versions",
      target_root: temp_dir
    )

    Rubysmith::Container.stub! logger:, kernel:, io:
  end

  after { Rubysmith::Container.restore }
end
