# frozen_string_literal: true

require "cogger"
require "dry-container"
require "etcher"
require "runcom"
require "spek"

module Rubysmith
  # Provides a global gem container for injection into other objects.
  module Container
    extend Dry::Container::Mixin

    register :configuration do
      self[:defaults].add_loader(Etcher::Loaders::YAML.new(self[:xdg_config].active))
                     .then { |registry| Etcher.call registry }
    end

    register :defaults do
      Etcher::Registry.new(contract: Configuration::Contract, model: Configuration::Model)
                      .add_loader(Etcher::Loaders::YAML.new(self[:defaults_path]))
                      .add_transformer(Configuration::Transformers::CurrentTime)
                      .add_transformer(Configuration::Transformers::GitHubUser)
                      .add_transformer(Configuration::Transformers::GitEmail)
                      .add_transformer(Configuration::Transformers::GitUser)
                      .add_transformer(Configuration::Transformers::TemplateRoot)
                      .add_transformer(Configuration::Transformers::TargetRoot)
    end

    register(:input, memoize: true) { self[:configuration].dup }
    register(:defaults_path) { Pathname(__dir__).join("configuration/defaults.yml") }
    register(:xdg_config) { Runcom::Config.new "rubysmith/configuration.yml" }
    register(:specification) { Spek::Loader.call "#{__dir__}/../../rubysmith.gemspec" }
    register(:kernel) { Kernel }
    register(:logger) { Cogger.new formatter: :emoji }
  end
end
