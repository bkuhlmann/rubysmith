# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::CircleCI do
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application container"

  let(:build_path) { temp_dir.join "test/.circleci/config.yml" }

  it_behaves_like "a builder"

  describe "#call" do
    context "when enabled" do
      let(:test_configuration) { configuration.minimize.merge build_circle_ci: true }

      it "builds configuration" do
        builder.call

        expect(build_path.read).to eq(<<~CONTENT)
          version: 2.1
          jobs:
            build:
              working_directory: ~/project
              docker:
                - image: bkuhlmann/alpine-ruby:latest
              steps:
                - checkout

                - restore_cache:
                    name: Bundler Restore
                    keys:
                      - gem-cache-{{.Branch}}-{{checksum "Gemfile.lock"}}
                      - gem-cache-

                - run:
                    name: Bundler Install
                    command: |
                      gem update --system
                      bundle config set path "vendor/bundle"
                      bundle install

                - save_cache:
                    name: Bundler Store
                    key: gem-cache-{{.Branch}}-{{checksum "Gemfile.lock"}}
                    paths:
                      - vendor/bundle

                - run:
                    name: Build
                    command: bundle exec rake
        CONTENT
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "does not build configuration" do
        builder.call
        expect(build_path.exist?).to eq(false)
      end
    end
  end
end
