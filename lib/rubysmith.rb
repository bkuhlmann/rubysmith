# frozen_string_literal: true

require "zeitwerk"

Zeitwerk::Loader.new.then do |loader|
  loader.inflector.inflect "cli" => "CLI",
                           "circle_ci" => "CircleCI",
                           "erb" => "ERB",
                           "git_hub_ci" => "GitHubCI",
                           "rspec" => "RSpec"
  loader.tag = File.basename __FILE__, ".rb"
  loader.push_dir __dir__
  loader.setup
end

# Main namespace.
module Rubysmith
  def self.loader(registry = Zeitwerk::Registry) = registry.loader_for __FILE__
end
