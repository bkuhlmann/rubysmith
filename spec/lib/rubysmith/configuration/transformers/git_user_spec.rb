# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Configuration::Transformers::GitUser do
  subject(:transformer) { described_class.new git: }

  let(:git) { instance_double Gitt::Repository }

  describe "#call" do
    it "answers full custom name when present" do
      result = transformer.call({author_given_name: "Test", author_family_name: "Example"})
      expect(result).to be_success(author_given_name: "Test", author_family_name: "Example")
    end

    it "answers given name with custom given name only" do
      expect(transformer.call({author_given_name: "Test"})).to be_success(author_given_name: "Test")
    end

    it "answers family name with custom family name only" do
      expect(transformer.call({author_family_name: "Example"})).to be_success(
        author_family_name: "Example"
      )
    end

    it "answers full Git name when custom user is missing and Git user exists" do
      allow(git).to receive(:get).with("user.name", nil).and_return(Success("Git Example"))

      expect(transformer.call({})).to be_success(
        author_given_name: "Git", author_family_name: "Example"
      )
    end

    it "answers original attributes when custom and Git users are missing" do
      allow(git).to receive(:get).with("user.name", nil).and_return(Success(nil))
      expect(transformer.call({})).to be_success({})
    end

    it "answers original attributes when custom user is missing and Git user is a failure" do
      allow(git).to receive(:get).with("user.name", nil).and_return(Failure("Danger!"))
      expect(transformer.call({})).to be_success({})
    end
  end
end
