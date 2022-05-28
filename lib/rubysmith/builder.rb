# frozen_string_literal: true

require "refinements/pathnames"
require "open3"
require "logger"

module Rubysmith
  # Provides common functionality necessary for all builders.
  class Builder
    include Import[:logger]

    using Refinements::Pathnames

    HELPERS = {inserter: Text::Inserter, renderer: Renderers::ERB, kernel: Open3}.freeze

    def self.call(...) = new(...)

    def initialize configuration, helpers: HELPERS, **dependencies
      super(**dependencies)
      @configuration = configuration
      @helpers = helpers
    end

    def append content
      log_debug "Appending: #{relative_build_path}"
      build_path.rewrite { |body| body + content }
      self
    end

    def delete
      log_debug "Deleting: #{relative_build_path}"
      build_path.delete
      self
    end

    def insert_before pattern, content
      log_debug "Inserting content before pattern in: #{relative_build_path}"
      build_path.write inserter.new(build_path.readlines, :before).call(content, pattern).join
      self
    end

    def insert_after pattern, content
      log_debug "Inserting content after pattern in: #{relative_build_path}"
      build_path.write inserter.new(build_path.readlines, :after).call(content, pattern).join
      self
    end

    def permit mode
      log_debug "Changing permissions for: #{relative_build_path}"
      build_path.chmod mode
      self
    end

    def prepend content
      log_debug "Prepending content to: #{relative_build_path}"
      build_path.rewrite { |body| content + body }
      self
    end

    def rename name
      log_debug "Renaming: #{build_path.basename} to #{name}"
      build_path.rename build_path.parent.join(name)
      self
    end

    def render
      log_debug "Rendering: #{relative_build_path}"

      pathway.start_path.read.then do |content|
        build_path.make_ancestors.write renderer.call(content)
      end

      self
    end

    def replace pattern, content
      log_debug "Replacing content for patterns in: #{relative_build_path}"
      build_path.rewrite { |body| body.gsub pattern, content }
      self
    end

    def run *command
      log_debug "Running: #{command}"
      execute(*command)
      self
    rescue StandardError => error
      log_error error and self
    end

    def touch
      log_debug "Touching: #{relative_build_path}"
      build_path.deep_touch
      self
    end

    private

    attr_reader :configuration, :helpers

    def execute *command
      kernel.capture2e(*command).then do |result, status|
        log_error result unless status.success?
      end
    end

    def inserter = helpers.fetch(__method__)

    def renderer = helpers.fetch(__method__).new(configuration)

    def kernel = helpers.fetch(__method__)

    def relative_build_path = build_path.relative_path_from(configuration.target_root)

    def build_path
      pathway.end_path
             .gsub("%project_name%", configuration.project_name)
             .sub("%project_path%", configuration.project_path)
             .sub ".erb", ""
    end

    def pathway = configuration.pathway

    def log_debug(message) = logger.debug { message }

    def log_error(message) = logger.error { message }
  end
end
