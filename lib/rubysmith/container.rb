# frozen_string_literal: true

require "cogger"
require "dry-container"
require "pastel"
require "spek"

module Rubysmith
  # Provides a global gem container for injection into other objects.
  module Container
    extend Dry::Container::Mixin

    register(:colorizer) { Pastel.new enabled: $stdout.tty? }
    register(:configuration) { Configuration::Loader.call }
    register(:specification) { Spek::Loader.call "#{__dir__}/../../rubysmith.gemspec" }
    register(:kernel) { Kernel }
    register(:logger) { Cogger::Client.new }
  end
end
