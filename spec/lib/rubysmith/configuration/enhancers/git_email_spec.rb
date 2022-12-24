# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Configuration::Enhancers::GitEmail do
  subject(:enhancer) { described_class.new git: }

  let(:git) { instance_double Gitt::Repository }

  describe "#call" do
    let(:content) { Rubysmith::Configuration::Content[author_email: "test@example.com"] }

    before { allow(git).to receive(:get).with("user.email").and_return(email) }

    context "with missing defaults and no Git email" do
      let(:content) { Rubysmith::Configuration::Content.new }
      let(:email) { nil }

      it "answers nil" do
        expect(enhancer.call(content)).to have_attributes(author_email: nil)
      end
    end

    context "with missing defaults and existing Git email" do
      let(:content) { Rubysmith::Configuration::Content.new }
      let(:email) { "git@example.com" }

      it "answers Git email" do
        expect(enhancer.call(content)).to have_attributes(author_email: "git@example.com")
      end
    end

    context "with defaults and no Git email" do
      let(:email) { nil }

      it "answers default email" do
        expect(enhancer.call(content)).to have_attributes(author_email: "test@example.com")
      end
    end

    context "with defaults and blank Git email" do
      let(:email) { "" }

      it "answers default email" do
        expect(enhancer.call(content)).to have_attributes(author_email: "test@example.com")
      end
    end

    context "with defaults and Git email" do
      let(:email) { "git@example.com" }

      it "answers default email" do
        expect(enhancer.call(content)).to have_attributes(author_email: "test@example.com")
      end
    end
  end
end
