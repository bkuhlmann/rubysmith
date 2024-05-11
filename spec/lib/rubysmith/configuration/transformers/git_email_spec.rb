# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Configuration::Transformers::GitEmail do
  include Dry::Monads[:result]

  subject(:transformer) { described_class.new git: }

  let(:git) { instance_double Gitt::Repository }

  describe "#call" do
    it "answers custom email when present" do
      expect(transformer.call({author_email: "test@example.com"})).to eq(
        Success(author_email: "test@example.com")
      )
    end

    it "answers Git email when custom email is missing and Git email exists" do
      allow(git).to receive(:get).with("user.email", nil).and_return(Success("git@example.com"))
      expect(transformer.call({})).to eq(Success(author_email: "git@example.com"))
    end

    it "answers original attributes when custom and Git emails are missing" do
      allow(git).to receive(:get).with("user.email", nil).and_return(Success(nil))
      expect(transformer.call({})).to eq(Success({}))
    end

    it "answers original attributes when custom user is missing and Git email is a failure" do
      allow(git).to receive(:get).with("user.email", nil).and_return(Failure("Danger!"))
      expect(transformer.call({})).to eq(Success({}))
    end
  end
end
