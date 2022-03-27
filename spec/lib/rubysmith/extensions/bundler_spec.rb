# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Extensions::Bundler do
  using Refinements::Pathnames

  subject(:builder) { described_class.new configuration, client: }

  include_context "with application dependencies"

  let(:client) { class_spy Bundler::CLI }

  before { temp_dir.join("test/Gemfile").make_ancestors.write(%(source "https://rubygems.org")) }

  describe ".call" do
    it "answers configuration" do
      expect(described_class.call(configuration, client:)).to be_a(
        Rubysmith::Configuration::Content
      )
    end
  end

  describe "#call" do
    it "installs gems" do
      builder.call
      expect(client).to have_received(:start).with(%w[install --quiet])
    end
  end
end
