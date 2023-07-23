# frozen_string_literal: true

require "cogger"
require "dry-container"
require "etcher"
require "gitt"
require "runcom"
require "spek"

module Rubysmith
  # Provides a global gem container for injection into other objects.
  module Container
    extend Dry::Container::Mixin

    register :configuration, memoize: true do
      self[:defaults].add_loader(Etcher::Loaders::YAML.new(self[:xdg_config].active))
                     .then { |registry| Etcher.call registry }
    end

    register :defaults, memoize: true do
      Etcher::Registry.new(contract: Configuration::Contract, model: Configuration::Model)
                      .add_loader(Etcher::Loaders::YAML.new(self[:defaults_path]))
                      .add_transformer(Configuration::Transformers::CurrentTime)
                      .add_transformer(Configuration::Transformers::GitHubUser.new)
                      .add_transformer(Configuration::Transformers::GitEmail.new)
                      .add_transformer(Configuration::Transformers::GitUser.new)
                      .add_transformer(Configuration::Transformers::TemplateRoot.new)
                      .add_transformer(Configuration::Transformers::TargetRoot)
    end

    register :specification, memoize: true do
      Spek::Loader.call "#{__dir__}/../../rubysmith.gemspec"
    end

    register(:input, memoize: true) { self[:configuration].dup }
    register(:defaults_path, memoize: true) { Pathname(__dir__).join("configuration/defaults.yml") }
    register(:xdg_config, memoize: true) { Runcom::Config.new "rubysmith/configuration.yml" }
    register(:git, memoize: true) { Gitt::Repository.new }
    register(:logger, memoize: true) { Cogger.new formatter: :emoji }
    register :kernel, Kernel
  end
end
