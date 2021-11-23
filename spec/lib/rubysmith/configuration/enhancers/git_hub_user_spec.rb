# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Configuration::Enhancers::GitHubUser do
  subject(:enhancer) { described_class.new repository: repository }

  let(:content) { Rubysmith::Configuration::Content[git_hub_user: "manual"] }
  let(:repository) { instance_double GitPlus::Repository, config_get: user }

  describe "#call" do
    context "with nil content and GitHub users" do
      let(:user) { nil }

      it "answers nil user" do
        content = Rubysmith::Configuration::Content.new
        expect(enhancer.call(content)).to have_attributes(git_hub_user: nil)
      end
    end

    context "with exiting content user and nil GitHub user" do
      let(:user) { nil }

      it "answers manually defined user" do
        expect(enhancer.call(content)).to have_attributes(git_hub_user: "manual")
      end
    end

    context "with exiting content user and blank GitHub user" do
      let(:user) { "" }

      it "answers manually defined user" do
        expect(enhancer.call(content)).to have_attributes(git_hub_user: "manual")
      end
    end

    context "with exiting content and GitHub users" do
      let(:user) { "dynamic" }

      it "answers nil user" do
        expect(enhancer.call(content)).to have_attributes(git_hub_user: "manual")
      end
    end

    context "with nil content user and existing GitHub user" do
      let(:user) { "dynamic" }

      it "answers nil user" do
        content = Rubysmith::Configuration::Content[git_hub_user: "dynamic"]
        expect(enhancer.call(content)).to have_attributes(git_hub_user: "dynamic")
      end
    end
  end
end
