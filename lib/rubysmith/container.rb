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
                      .add_transformer(:basename, :project_name)
                      .add_transformer(:format, :author_uri)
                      .add_transformer(:format, :project_uri_community)
                      .add_transformer(:format, :project_uri_conduct)
                      .add_transformer(:format, :project_uri_contributions)
                      .add_transformer(:format, :project_uri_download)
                      .add_transformer(:format, :project_uri_funding)
                      .add_transformer(:format, :project_uri_home)
                      .add_transformer(:format, :project_uri_issues)
                      .add_transformer(:format, :project_uri_license)
                      .add_transformer(:format, :project_uri_security)
                      .add_transformer(:format, :project_uri_source)
                      .add_transformer(:format, :project_uri_versions)
                      .add_transformer(:time, :loaded_at)
    end

    register(:settings) { Etcher.call self[:registry] }
    register(:specification) { Spek::Loader.call "#{__dir__}/../../rubysmith.gemspec" }
    register(:defaults_path) { Pathname(__dir__).join("configuration/defaults.yml") }
    register(:xdg_config) { Runcom::Config.new "rubysmith/settings.yml" }
    register(:git) { Gitt::Repository.new }
    register(:logger) { Cogger.new id: :rubysmith }
    register :kernel, Kernel
    register :io, STDOUT
  end
end
