# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Configuration::Transformers::GitHubUser do
  include Dry::Monads[:result]

  subject(:transformer) { described_class }

  describe "#call" do
    let(:content) { {git_hub_user: "default"} }
    let(:user) { Failure "Danger!" }
    let(:git) { instance_double Gitt::Repository }

    before { allow(git).to receive(:get).with("github.user").and_return(user) }

    it "answers default user when present" do
      expect(transformer.call(content, git:)).to eq(Success(git_hub_user: "default"))
    end

    context "without default user and with GitHub user" do
      let(:content) { {} }
      let(:user) { Success "git_hub" }

      it "answers GitHub user" do
        expect(transformer.call(content, git:)).to eq(Success(git_hub_user: "git_hub"))
      end
    end

    context "without default user and GitHub user" do
      let(:content) { {} }

      it "answers failure" do
        expect(transformer.call(content, git:)).to eq(Failure("Danger!"))
      end
    end
  end
end
