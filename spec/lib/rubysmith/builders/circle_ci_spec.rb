# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::CircleCI do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    let(:build_path) { temp_dir.join "test/.circleci/config.yml" }

    it "builds configuration when enabled" do
      settings.merge! settings.minimize.merge(build_circle_ci: true)
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

    it "does not build configuration when disabled" do
      settings.merge! settings.minimize
      builder.call

      expect(build_path.exist?).to be(false)
    end
  end
end
