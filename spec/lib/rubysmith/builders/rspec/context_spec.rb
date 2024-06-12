# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::RSpec::Context do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:context_path) { temp_dir.join "test", "spec", "support", "shared_contexts", "temp_dir.rb" }

    context "when enabled with refinements" do
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

      before do
        settings.merge! settings.minimize.merge(build_rspec: true, build_refinements: true)
      end

      it "builds temporary directory shared context" do
        builder.call
        expect(context_path.read).to eq(content)
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when enabled without refinements" do
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

      before do
        settings.merge! settings.minimize.merge(build_rspec: true, build_refinements: false)
      end

      it "builds temporary directory shared context" do
        builder.call
        expect(context_path.read).to eq(content)
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't build temporary directory shared context" do
        builder.call
        expect(context_path.exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
