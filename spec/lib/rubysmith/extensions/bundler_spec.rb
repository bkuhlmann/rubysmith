# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Extensions::Bundler do
  using Refinements::Pathname

  subject(:extension) { described_class.new client: }

  include_context "with application dependencies"

  let(:client) { class_spy Bundler::CLI }

  describe "#call" do
    before { temp_dir.join("test/Gemfile").make_ancestors.write(%(source "#{settings.gems_uri}")) }

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

    context "without internet" do
      before { allow(client).to receive(:start).and_raise Bundler::HTTPError, "Danger!" }

      it "logs error when there is no internet connection" do
        extension.call
        expect(logger.reread).to match(%r(🛑.+Unable to install gem dependencies...))
      end

      it "answers false" do
        expect(extension.call).to be(false)
      end
    end
  end
end
