# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::CircleCI do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:build_path) { temp_dir.join "test/.circleci/config.yml" }

    context "when enabled" do
      before { settings.merge! settings.minimize.merge(build_circle_ci: true) }

      it "builds configuration when enabled" do
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
                    name: Gems Restore
                    keys:
                      - gem-cache-{{.Branch}}-{{checksum "Gemfile.lock"}}
                      - gem-cache-

                - run:
                    name: Gems Install
                    command: |
                      gem update --system
                      bundle config set path "vendor/bundle"
                      bundle install

                - save_cache:
                    name: Gems Store
                    key: gem-cache-{{.Branch}}-{{checksum "Gemfile.lock"}}
                    paths:
                      - vendor/bundle

                - run:
                    name: Rake
                    command: bundle exec rake
        CONTENT
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    it "builds configuration when enabled with SimpleCov" do
      settings.merge! settings.minimize.merge(build_circle_ci: true, build_simple_cov: true)
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
                  name: Gems Restore
                  keys:
                    - gem-cache-{{.Branch}}-{{checksum "Gemfile.lock"}}
                    - gem-cache-

              - run:
                  name: Gems Install
                  command: |
                    gem update --system
                    bundle config set path "vendor/bundle"
                    bundle install

              - save_cache:
                  name: Gems Store
                  key: gem-cache-{{.Branch}}-{{checksum "Gemfile.lock"}}
                  paths:
                    - vendor/bundle

              - run:
                  name: Rake
                  command: bundle exec rake

              - store_artifacts:
                  name: SimpleCov Report
                  path: ~/project/coverage
                  destination: coverage
      CONTENT
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "does not build configuration" do
        builder.call
        expect(build_path.exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
