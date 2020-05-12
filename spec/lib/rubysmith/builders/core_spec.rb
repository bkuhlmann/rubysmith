# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Core, :realm do
  subject(:builder) { described_class.new default_realm }

  let :identity_content do
    <<~CONTENT
      module Test
        module Identity
          NAME = "test"
          LABEL = "Test"
          VERSION = "0.1.0"
          VERSION_LABEL = "\#{LABEL} \#{VERSION}"
        end
      end
    CONTENT
  end

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    it "builds project identity" do
      expect(temp_dir.join("test", "lib", "test", "identity.rb").read).to eq(identity_content.chomp)
    end

    it "builds project file" do
      expect(temp_dir.join("test", "lib", "test.rb").read).to eq(%(require "test/identity"\n))
    end

    it "builds Ruby version file" do
      expect(temp_dir.join("test", ".ruby-version").read).to eq(RUBY_VERSION)
    end
  end
end
