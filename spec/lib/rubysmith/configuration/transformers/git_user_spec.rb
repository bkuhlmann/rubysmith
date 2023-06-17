# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Configuration::Transformers::GitUser do
  include Dry::Monads[:result]

  subject(:transformer) { described_class.new git: }

  let(:git) { instance_double Gitt::Repository }

  describe "#call" do
    let(:content) { {author_given_name: "Test", author_family_name: "Example"} }
    let(:user) { Failure "Danger!" }

    before { allow(git).to receive(:get).with("user.name").and_return(user) }

    it "answers default given and family name when present" do
      expect(transformer.call(content)).to eq(
        Success(author_given_name: "Test", author_family_name: "Example")
      )
    end

    context "without default given or family name and with GitHub user" do
      let(:user) { Success "Git Example" }

      it "answers Git user given and family name" do
        expect(transformer.call({})).to eq(
          Success(
            author_given_name: "Git", author_family_name: "Example"
          )
        )
      end
    end

    it "answers given name with default given name only" do
      expect(transformer.call({author_given_name: "Test"})).to eq(
        Success(author_given_name: "Test")
      )
    end

    it "answers family name with default family name only" do
      expect(transformer.call({author_family_name: "Example"})).to eq(
        Success(author_family_name: "Example")
      )
    end

    it "answers failure without default given or family name and Git user" do
      expect(transformer.call({})).to eq(Failure("Danger!"))
    end
  end
end
