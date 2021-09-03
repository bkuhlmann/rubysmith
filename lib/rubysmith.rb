# frozen_string_literal: true

require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect "cli" => "CLI", "erb" => "ERB", "rspec" => "RSpec"
loader.setup

# Main namespace.
module Rubysmith
end
