# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Configuration::Transformers::GitEmail do
  include Dry::Monads[:result]

  subject(:transformer) { described_class }

  describe "#call" do
    let(:content) { {author_email: "test@example.com"} }
    let(:email) { Failure "Danger!" }
    let(:git) { instance_double Gitt::Repository }

    before { allow(git).to receive(:get).with("user.email").and_return(email) }

    it "answers default email when present" do
      expect(transformer.call(content, git:)).to eq(Success(author_email: "test@example.com"))
    end

    context "without default email and with Git email" do
      let(:content) { {} }
      let(:email) { Success "git@example.com" }

      it "answers Git email" do
        expect(transformer.call(content, git:)).to eq(Success(author_email: "git@example.com"))
      end
    end

    context "without default email and Git email" do
      let(:content) { {} }

      it "answers failure" do
        expect(transformer.call(content, git:)).to eq(Failure("Danger!"))
      end
    end
  end
end
