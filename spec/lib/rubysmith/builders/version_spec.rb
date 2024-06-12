# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Version do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  using Refinements::Struct

  describe "#call" do
    it "builds Ruby version file with minimum settings" do
      settings.merge! settings.minimize
      builder.call

      expect(temp_dir.join("test", ".ruby-version").read).to eq("#{RUBY_VERSION}\n")
    end

    it "builds Ruby version file with maximum settings" do
      settings.merge! settings.maximize
      builder.call

      expect(temp_dir.join("test", ".ruby-version").read).to eq("#{RUBY_VERSION}\n")
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
