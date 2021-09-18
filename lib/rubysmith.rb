# frozen_string_literal: true

require "zeitwerk"

Zeitwerk::Loader.for_gem.then do |loader|
  loader.inflector.inflect "cli" => "CLI",
                           "circle_ci" => "CircleCI",
                           "erb" => "ERB",
                           "rspec" => "RSpec"
  loader.setup
end

# Main namespace.
module Rubysmith
end
