# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Docker::File do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test", "Dockerfile" }

    context "when enabled" do
      before { settings.build_docker = true }

      it "sets Ruby version argument" do
        builder.call
        expect(path.read).to include("ARG RUBY_VERSION=#{RUBY_VERSION}")
      end

      it "sets default description label" do
        builder.call
        expect(path.read).to include(%(LABEL description="Application"))
      end

      it "sets custom default description label" do
        settings.organization_label = "Test"
        builder.call

        expect(path.read).to include(%(LABEL description="Test Application"))
      end

      it "sets maintainer label" do
        builder.call
        expect(path.read).to include(%(LABEL maintainer="Jill Smith <jill@acme.io>"))
      end

      it "includes bootsnap gemfile precompile when enabled" do
        settings.build_bootsnap = true
        builder.call

        expect(path.read).to include(<<~SNIPPET)
          RUN <<STEPS
            bundle install
            rm -rf "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git
            bundle exec bootsnap precompile --gemfile
          STEPS
        SNIPPET
      end

      it "excludes bootsnap gemfile precompile when disabled" do
        settings.build_bootsnap = false
        builder.call

        expect(path.read).to include(<<~SNIPPET)
          RUN <<STEPS
            bundle install
            rm -rf "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git
          STEPS
        SNIPPET
      end

      it "includes bootsnap lib precompile when enabled" do
        settings.build_bootsnap = true
        builder.call

        expect(path.read).to include("RUN bundle exec bootsnap precompile app/")
      end

      it "excludes bootsnap lib precompile when disabled" do
        settings.build_bootsnap = false
        builder.call

        expect(path.read).not_to include("RUN bundle exec bootsnap precompile app/")
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't build file" do
        builder.call
        expect(path.exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
