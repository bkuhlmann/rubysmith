# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Configuration::Transformers::GitUser do
  include Dry::Monads[:result]

  subject(:transformer) { described_class }

  describe "#call" do
    let :content do
      {author_given_name: "Test", author_family_name: "Example"}
    end

    let(:user) { Failure "Danger!" }
    let(:git) { instance_double Gitt::Repository }

    before { allow(git).to receive(:get).with("user.name").and_return(user) }

    it "answers default given and family name when present" do
      expect(transformer.call(content, git:)).to eq(
        Success(author_given_name: "Test", author_family_name: "Example")
      )
    end

    context "without default given or family name and with GitHub user" do
      let(:content) { {} }
      let(:user) { Success "Git Example" }

      it "answers Git user given and family name" do
        expect(transformer.call(content, git:)).to eq(
          Success(
            author_given_name: "Git", author_family_name: "Example"
          )
        )
      end
    end

    context "with default given name only" do
      let(:content) { {author_given_name: "Test"} }

      it "answers given name" do
        expect(transformer.call(content, git:)).to eq(Success(author_given_name: "Test"))
      end
    end

    context "with default family name only" do
      let(:content) { {author_family_name: "Example"} }

      it "answers family name" do
        expect(transformer.call(content, git:)).to eq(Success(author_family_name: "Example"))
      end
    end

    context "without default given or family name and Git user" do
      let(:content) { {} }

      it "answers failure" do
        expect(transformer.call(content, git:)).to eq(Failure("Danger!"))
      end
    end
  end
end
