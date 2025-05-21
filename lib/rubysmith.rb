# frozen_string_literal: true

require "zeitwerk"

Zeitwerk::Loader.new.then do |loader|
  loader.inflector.inflect "cli" => "CLI",
                           "ci" => "CI",
                           "circle_ci" => "CircleCI",
                           "dcoo" => "DCOO",
                           "erb" => "ERB",
                           "git_hub_ci" => "GitHubCI",
                           "irb_kit" => "IRBKit",
                           "rspec" => "RSpec",
                           "rtc" => "RTC"
  loader.tag = File.basename __FILE__, ".rb"
  loader.push_dir __dir__
  loader.setup
end

# Main namespace.
module Rubysmith
  def self.loader registry = Zeitwerk::Registry
    @loader ||= registry.loaders.each.find { |loader| loader.tag == File.basename(__FILE__, ".rb") }
  end
end
