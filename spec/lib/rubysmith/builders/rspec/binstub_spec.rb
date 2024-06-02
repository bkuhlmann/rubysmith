# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::RSpec::Binstub do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    let(:binstub_path) { temp_dir.join "test", "bin", "rspec" }

    it "builds binstub when enabled" do
      settings.merge! settings.minimize.merge(build_rspec: true)
      builder.call

      expect(binstub_path.read).to eq(<<~CONTENT)
        #! /usr/bin/env ruby

        require "bundler/setup"

        load Gem.bin_path "rspec-core", "rspec"
      CONTENT
    end

    it "updates file permissions when enabled" do
      settings.merge! settings.minimize.merge(build_rspec: true)
      builder.call

      expect(binstub_path.stat.mode).to eq(33261)
    end

    it "doesn't build binstub when disabled" do
      settings.merge! settings.minimize
      builder.call

      expect(binstub_path.exist?).to be(false)
    end
  end
end
