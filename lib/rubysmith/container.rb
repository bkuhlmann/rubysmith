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

    register :registry do
      Etcher::Registry.new(contract: Configuration::Contract, model: Configuration::Model)
                      .add_loader(:yaml, self[:defaults_path])
                      .add_loader(:yaml, self[:xdg_config].active)
                      .add_transformer(Configuration::Transformers::GitHubUser.new)
                      .add_transformer(Configuration::Transformers::GitEmail.new)
                      .add_transformer(Configuration::Transformers::GitUser.new)
                      .add_transformer(Configuration::Transformers::TemplateRoot.new)
                      .add_transformer(:root, :target_root)
                      .add_transformer(:time, :loaded_at)
    end

    register(:settings) { Etcher.call(self[:registry]).dup }
    register(:specification) { Spek::Loader.call "#{__dir__}/../../rubysmith.gemspec" }
    register(:defaults_path) { Pathname(__dir__).join("configuration/defaults.yml") }
    register(:xdg_config) { Runcom::Config.new "rubysmith/configuration.yml" }
    register(:git) { Gitt::Repository.new }
    register(:logger) { Cogger.new id: :rubysmith }
    register :kernel, Kernel
    register :io, STDOUT
  end
end
