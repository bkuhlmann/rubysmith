# frozen_string_literal: true

require "cogger"
require "dry-container"
require "spek"
require "tone"

module Rubysmith
  # Provides a global gem container for injection into other objects.
  module Container
    extend Dry::Container::Mixin

    register(:color) { Tone.new }
    register(:configuration) { Configuration::Loader.call }
    register(:specification) { Spek::Loader.call "#{__dir__}/../../rubysmith.gemspec" }
    register(:kernel) { Kernel }
    register(:logger) { Cogger::Client.new }
  end
end
