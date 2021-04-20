# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Core do
  subject(:builder) { described_class.new default_configuration }

  include_context "with configuration"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    it "builds project file" do
      expect(temp_dir.join("test", "lib", "test.rb").read).to eq(<<~CONTENT)
        # The project namespace.
        module Test
        end
      CONTENT
    end

    it "builds Ruby version file" do
      expect(temp_dir.join("test", ".ruby-version").read).to eq(RUBY_VERSION)
    end
  end
end
