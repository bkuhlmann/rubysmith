# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Configuration::Enhancers::GitUser do
  include Dry::Monads[:result]

  subject(:enhancer) { described_class }

  describe "#call" do
    let(:git) { instance_double Gitt::Repository }

    let :content do
      Rubysmith::Configuration::Content[author_given_name: "Test", author_family_name: "Example"]
    end

    before { allow(git).to receive(:get).with("user.name").and_return(user) }

    context "with missing defaults and no Git user" do
      let(:content) { Rubysmith::Configuration::Content.new }
      let(:user) { Success nil }

      it "answers blank author" do
        expect(enhancer.call(content, git:)).to have_attributes(author_name: "")
      end
    end

    context "with missing defaults and existing Git user" do
      let(:content) { Rubysmith::Configuration::Content.new }
      let(:user) { Success "Git Test" }

      it "answers Git author" do
        expect(enhancer.call(content, git:)).to have_attributes(author_name: "Git Test")
      end
    end

    context "with defaults and no Git user" do
      let(:user) { Success nil }

      it "answers default author" do
        expect(enhancer.call(content, git:)).to have_attributes(author_name: "Test Example")
      end
    end

    context "with defaults and blank Git user" do
      let(:user) { Success "" }

      it "answers default author" do
        expect(enhancer.call(content, git:)).to have_attributes(author_name: "Test Example")
      end
    end

    context "with defaults and Git user" do
      let(:user) { Success "Git Test" }

      it "answers default author" do
        expect(enhancer.call(content, git:)).to have_attributes(author_name: "Test Example")
      end
    end

    context "with user failure" do
      let(:user) { Failure() }

      it "answers default author" do
        expect(enhancer.call(content, git:)).to have_attributes(author_name: "Test Example")
      end
    end
  end
end
