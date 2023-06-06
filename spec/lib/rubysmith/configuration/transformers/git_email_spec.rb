# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Configuration::Transformers::GitEmail do
  include Dry::Monads[:result]

  subject(:enhancer) { described_class }

  let(:git) { instance_double Gitt::Repository }

  describe "#call" do
    let(:content) { Rubysmith::Configuration::Model[author_email: "test@example.com"] }

    before { allow(git).to receive(:get).with("user.email").and_return(email) }

    context "with missing defaults and no Git email" do
      let(:content) { Rubysmith::Configuration::Model.new }
      let(:email) { Success nil }

      it "answers nil" do
        expect(enhancer.call(content, git:)).to have_attributes(author_email: nil)
      end
    end

    context "with missing defaults and existing Git email" do
      let(:content) { Rubysmith::Configuration::Model.new }
      let(:email) { Success "git@example.com" }

      it "answers Git email" do
        expect(enhancer.call(content, git:)).to have_attributes(author_email: "git@example.com")
      end
    end

    context "with defaults and no Git email" do
      let(:email) { Success nil }

      it "answers default email" do
        expect(enhancer.call(content, git:)).to have_attributes(author_email: "test@example.com")
      end
    end

    context "with defaults and blank Git email" do
      let(:email) { Success "" }

      it "answers default email" do
        expect(enhancer.call(content, git:)).to have_attributes(author_email: "test@example.com")
      end
    end

    context "with defaults and Git email" do
      let(:email) { Success "git@example.com" }

      it "answers default email" do
        expect(enhancer.call(content, git:)).to have_attributes(author_email: "test@example.com")
      end
    end

    context "with defaults and email failure" do
      let(:email) { Failure "Danger!" }

      it "answers default email" do
        expect(enhancer.call(content, git:)).to have_attributes(author_email: "test@example.com")
      end
    end
  end
end
