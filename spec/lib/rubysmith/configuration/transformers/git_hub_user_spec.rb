# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Configuration::Transformers::GitHubUser do
  include Dry::Monads[:result]

  subject(:transformer) { described_class.new git: }

  let(:git) { instance_double Gitt::Repository }

  describe "#call" do
    it "answers custom user when present" do
      expect(transformer.call({repository_handle: "test"})).to eq(
        Success(repository_handle: "test")
      )
    end

    it "answers GitHub user when custom user is missing and GitHub user exists" do
      allow(git).to receive(:get).with("github.user", nil).and_return(Success("test"))
      expect(transformer.call({})).to eq(Success(repository_handle: "test"))
    end

    it "answers original attributes when custom and GitHub users are missing" do
      allow(git).to receive(:get).with("github.user", nil).and_return(Success(nil))
      expect(transformer.call({})).to eq(Success({}))
    end

    it "answers original attributes when custom user is missing and GitHub user is a failure" do
      allow(git).to receive(:get).with("github.user", nil).and_return(Failure("Danger!"))
      expect(transformer.call({})).to eq(Success({}))
    end
  end
end
