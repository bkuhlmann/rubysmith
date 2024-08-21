# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Extensions::Bundler do
  using Refinements::Pathname

  subject(:extension) { described_class.new client: }

  include_context "with application dependencies"

  let(:client) { class_spy Bundler::CLI }

  describe "#call" do
    before { temp_dir.join("test/Gemfile").make_ancestors.write(%(source "https://rubygems.org")) }

    it "logs info" do
      extension.call
      expect(logger.reread).to match(%r(🟢.+Installing gem dependencies...))
    end

    it "installs gems" do
      extension.call
      expect(client).to have_received(:start).with(%w[install --quiet])
    end

    it "adds Linux (x86) platform" do
      extension.call
      expect(client).to have_received(:start).with(%w[lock --add-platform x86_64-linux --update])
    end

    it "answers true" do
      expect(extension.call).to be(true)
    end
  end
end
