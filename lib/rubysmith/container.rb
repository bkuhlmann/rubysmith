# frozen_string_literal: true

require "cogger"
require "containable"
require "etcher"
require "gitt"
require "runcom"
require "spek"

module Rubysmith
  # Provides a global gem container for injection into other objects.
  module Container
    extend Containable

    register :configuration do
      self[:defaults].add_loader(Etcher::Loaders::YAML.new(self[:xdg_config].active))
                     .then { |registry| Etcher.call registry }
    end

    register :defaults do
      Etcher::Registry.new(contract: Configuration::Contract, model: Configuration::Model)
                      .add_loader(Etcher::Loaders::YAML.new(self[:defaults_path]))
                      .add_transformer(Configuration::Transformers::GitHubUser.new)
                      .add_transformer(Configuration::Transformers::GitEmail.new)
                      .add_transformer(Configuration::Transformers::GitUser.new)
                      .add_transformer(Configuration::Transformers::TemplateRoot.new)
                      .add_transformer(Configuration::Transformers::TargetRoot)
                      .add_transformer(Etcher::Transformers::Time.new)
    end

    register(:specification) { Spek::Loader.call "#{__dir__}/../../rubysmith.gemspec" }
    register(:input) { self[:configuration].dup }
    register(:defaults_path) { Pathname(__dir__).join("configuration/defaults.yml") }
    register(:xdg_config) { Runcom::Config.new "rubysmith/configuration.yml" }
    register(:git) { Gitt::Repository.new }
    register(:logger) { Cogger.new id: :rubysmith }
    register :kernel, Kernel
  end
end
