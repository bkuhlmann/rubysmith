# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::RSpec::Context do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test/spec/support/shared_contexts/temp_dir.rb" }

    context "when enabled" do
      let :content do
        <<~CONTENT
          RSpec.shared_context "with temporary directory" do
            let(:temp_dir) { Bundler.root.join "tmp/rspec" }

            around do |example|
              temp_dir.mkpath
              example.run
              temp_dir.rmtree
            end
          end
        CONTENT
      end

      before { settings.with! settings.minimize.with(build_rspec: true) }

      it "builds file" do
        builder.call
        expect(path.read).to eq(content)
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before { settings.with! settings.minimize }

      it "doesn't build file" do
        builder.call
        expect(path.exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
