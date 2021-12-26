# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Configuration::Enhancers::GitHubUser do
  subject(:enhancer) { described_class.new repository: }

  let(:repository) { instance_double GitPlus::Repository }

  describe "#call" do
    let(:content) { Rubysmith::Configuration::Content[git_hub_user: "default"] }

    before { allow(repository).to receive(:config_get).with("github.user").and_return(user) }

    context "with missing defaults and GitHub user" do
      let(:user) { nil }
      let(:content) { Rubysmith::Configuration::Content.new }

      it "answers nil user" do
        expect(enhancer.call(content)).to have_attributes(git_hub_user: nil)
      end
    end

    context "with missing defaults and existing GitHub user" do
      let(:user) { "git_hub" }
      let(:content) { Rubysmith::Configuration::Content.new }

      it "answers GitHub user" do
        expect(enhancer.call(content)).to have_attributes(git_hub_user: "git_hub")
      end
    end

    context "with defaults and nil GitHub user" do
      let(:user) { nil }

      it "answers default user" do
        expect(enhancer.call(content)).to have_attributes(git_hub_user: "default")
      end
    end

    context "with defaults and blank GitHub user" do
      let(:user) { "" }

      it "answers default user" do
        expect(enhancer.call(content)).to have_attributes(git_hub_user: "default")
      end
    end

    context "with defaults and GitHub user" do
      let(:user) { "dynamic" }

      it "answers default user" do
        expect(enhancer.call(content)).to have_attributes(git_hub_user: "default")
      end
    end
  end
end
