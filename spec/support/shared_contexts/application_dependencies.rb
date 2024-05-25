# frozen_string_literal: true

RSpec.shared_context "with application dependencies" do
  include_context "with temporary directory"

  let :configuration do
    Etcher.new(Rubysmith::Container[:defaults])
          .call(
            author_email: "jill@acme.io",
            author_family_name: "Smith",
            author_given_name: "Jill",
            author_url: "https://acme.io/team/jill_smith",
            citation_affiliation: "ACME",
            citation_orcid: "0000-1111-2222-3333",
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
          .bind(&:dup)
  end

  let(:input) { configuration.dup }
  let(:xdg_config) { Runcom::Config.new Rubysmith::Container[:defaults_path] }
  let(:kernel) { class_spy Kernel }
  let(:logger) { Cogger.new id: :rubysmith, io: StringIO.new, level: :debug }

  before { Rubysmith::Container.stub! configuration:, input:, xdg_config:, kernel:, logger: }

  after { Rubysmith::Container.restore }
end
