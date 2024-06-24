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
      Rubysmith::Container[:registry].remove_loader(1)
                                     .add_loader(:hash, project_name: "test"),
      author_email: "jill@acme.io",
      author_family_name: "Smith",
      author_given_name: "Jill",
      loaded_at: Time.utc(2020, 1, 1, 0, 0, 0),
      target_root: temp_dir
    )

    Rubysmith::Container.stub! logger:, kernel:, io:
  end

  after { Rubysmith::Container.restore }
end
