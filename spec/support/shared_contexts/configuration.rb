# frozen_string_literal: true

RSpec.shared_context "with configuration" do
  include_context "with temporary directory"

  let :default_configuration do
    Rubysmith::CLI::Configuration::Content[
      template_root: Bundler.root.join("lib", "rubysmith", "templates"),
      target_root: temp_dir,
      project_name: "test",
      author_name: "Jill Smith",
      author_email: "jill@example.com",
      author_url: "https://www.jillsmith.com",
      now: now,
      builders_pragmater_comments: ["# frozen_string_literal: true"],
      builders_pragmater_includes: ["**/*.rb"]
    ]
  end

  let(:now) { Time.local 2020, 1, 1, 0, 0, 0 }
end
