# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Configuration::Enhancers::GitHubUser do
  include Dry::Monads[:result]

  subject(:enhancer) { described_class }

  describe "#call" do
    let(:content) { Rubysmith::Configuration::Content[git_hub_user: "default"] }
    let(:git) { instance_double Gitt::Repository }

    before { allow(git).to receive(:get).with("github.user").and_return(user) }

    context "with missing defaults and GitHub user" do
      let(:user) { Success nil }
      let(:content) { Rubysmith::Configuration::Content.new }

      it "answers nil user" do
        expect(enhancer.call(content, git:)).to have_attributes(git_hub_user: nil)
      end
    end

    context "with missing defaults and existing GitHub user" do
      let(:user) { Success "git_hub" }
      let(:content) { Rubysmith::Configuration::Content.new }

      it "answers GitHub user" do
        expect(enhancer.call(content, git:)).to have_attributes(git_hub_user: "git_hub")
      end
    end

    context "with defaults and nil GitHub user" do
      let(:user) { Success nil }

      it "answers default user" do
        expect(enhancer.call(content, git:)).to have_attributes(git_hub_user: "default")
      end
    end

    context "with defaults and blank GitHub user" do
      let(:user) { Success "" }

      it "answers default user" do
        expect(enhancer.call(content, git:)).to have_attributes(git_hub_user: "default")
      end
    end

    context "with defaults and GitHub user" do
      let(:user) { Success "dynamic" }

      it "answers default user" do
        expect(enhancer.call(content, git:)).to have_attributes(git_hub_user: "default")
      end
    end

    context "with user failure" do
      let(:user) { Failure() }

      it "answers blank user" do
        expect(enhancer.call(content, git:)).to have_attributes(author_name: "")
      end
    end
  end
end
