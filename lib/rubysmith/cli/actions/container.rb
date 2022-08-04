# frozen_string_literal: true

require "dry/container"

module Rubysmith
  module CLI
    module Actions
      # Provides a single container with application and action specific dependencies.
      module Container
        extend Dry::Container::Mixin

        merge Rubysmith::Container

        register(:build) { Build.new }
        register(:config) { Config.new }
        register(:publish) { Publish.new }
      end
    end
  end
end
