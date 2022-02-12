# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Version do
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application container"

  using Refinements::Structs

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "with minimum configuration" do
      let(:test_configuration) { configuration.minimize }

      it "builds Ruby version file" do
        expect(temp_dir.join("test", ".ruby-version").read).to eq("#{RUBY_VERSION}\n")
      end
    end

    context "with maximum configuration" do
      let(:test_configuration) { configuration.maximize }

      it "builds Ruby version file" do
        expect(temp_dir.join("test", ".ruby-version").read).to eq("#{RUBY_VERSION}\n")
      end
    end
  end
end
