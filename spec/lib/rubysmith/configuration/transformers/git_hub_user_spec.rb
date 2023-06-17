# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Configuration::Transformers::GitHubUser do
  include Dry::Monads[:result]

  subject(:transformer) { described_class.new git: }

  let(:git) { instance_double Gitt::Repository }

  describe "#call" do
    let(:user) { Failure "Danger!" }

    before { allow(git).to receive(:get).with("github.user").and_return(user) }

    it "answers default user when present" do
      expect(transformer.call({git_hub_user: "default"})).to eq(Success(git_hub_user: "default"))
    end

    context "without default user and with GitHub user" do
      let(:user) { Success "git_hub" }

      it "answers GitHub user" do
        expect(transformer.call({})).to eq(Success(git_hub_user: "git_hub"))
      end
    end

    it "answers failure without default user and GitHub user" do
      expect(transformer.call({})).to eq(Failure("Danger!"))
    end
  end
end
