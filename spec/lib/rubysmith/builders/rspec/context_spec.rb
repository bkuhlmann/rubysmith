# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::RSpec::Context do
  using Refinements::Struct

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  let(:context_path) { temp_dir.join "test", "spec", "support", "shared_contexts", "temp_dir.rb" }

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "when enabled with refinements" do
      let :test_configuration do
        configuration.minimize.merge build_rspec: true, build_refinements: true
      end

      let :content do
        <<~CONTENT
          RSpec.shared_context "with temporary directory" do
            using Refinements::Pathname

            let(:temp_dir) { Bundler.root.join "tmp/rspec" }

            around do |example|
              temp_dir.make_path
              example.run
              temp_dir.remove_tree
            end
          end
        CONTENT
      end

      it "builds temporary directory shared context" do
        expect(context_path.read).to eq(content)
      end
    end

    context "when enabled without refinements" do
      let(:test_configuration) { configuration.minimize.merge build_rspec: true }

      let :content do
        <<~CONTENT
          RSpec.shared_context "with temporary directory" do
            let(:temp_dir) { Bundler.root.join "tmp/rspec" }

            around do |example|
              FileUtils.mkdir_p temp_dir
              example.run
              FileUtils.rm_rf temp_dir
            end
          end
        CONTENT
      end

      it "builds temporary directory shared context" do
        expect(context_path.read).to eq(content)
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "doesn't build temporary directory shared context" do
        expect(context_path.exist?).to be(false)
      end
    end
  end
end
