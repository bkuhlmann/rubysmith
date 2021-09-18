# frozen_string_literal: true

RSpec.shared_context "with configuration" do
  include_context "with temporary directory"

  let :default_configuration do
    Rubysmith::CLI::Configuration::Content[
      author_email: "jill@example.com",
      author_name: "Jill Smith",
      author_url: "https://www.jillsmith.com",
      builders_pragmater_comments: ["# frozen_string_literal: true"],
      builders_pragmater_includes: ["**/*.rb"],
      git_hub_user: "hubber",
      now: now,
      project_name: "test",
      target_root: temp_dir,
      template_root: Bundler.root.join("lib", "rubysmith", "templates")
    ]
  end

  let(:now) { Time.local 2020, 1, 1, 0, 0, 0 }
end
