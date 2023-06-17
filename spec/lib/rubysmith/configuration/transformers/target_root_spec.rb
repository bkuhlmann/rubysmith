# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Configuration::Transformers::TargetRoot do
  include Dry::Monads[:result]

  subject(:transformer) { described_class }

  describe "#call" do
    it "answers content path when key is present" do
      expect(transformer.call({target_root: "a/path"})).to eq(Success(target_root: "a/path"))
    end

    it "answers custom path with empty content" do
      expect(transformer.call({}, path: "a/path")).to eq(Success(target_root: "a/path"))
    end

    it "answers current directory with empty content" do
      expect(transformer.call({})).to eq(Success(target_root: Pathname.pwd))
    end
  end
end
