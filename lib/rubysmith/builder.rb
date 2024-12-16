# frozen_string_literal: true

require "open3"
require "refinements/pathname"

module Rubysmith
  # Provides common functionality necessary for all builders.
  class Builder
    include Dependencies[:logger]

    using Refinements::Pathname

    HELPERS = {inserter: Text::Inserter, renderer: Renderers::ERB, executor: Open3}.freeze

    def initialize(settings, helpers: HELPERS, **)
      @settings = settings
      @helpers = helpers
      super(**)
    end

    def append content
      log_debug "Appending content to: #{relative_build_path}"
      build_path.rewrite { |body| body + content }
      self
    end

    def check
      build_path.then do |path|
        path.exist? ? logger.abort("Path exists: #{path}.") : log_debug("Checked: #{path}.")
      end
    end

    def delete
      log_info "Deleting: #{relative_build_path}"
      build_path.delete
      self
    end

    def insert_after pattern, content
      log_debug "Inserting content after pattern in: #{relative_build_path}"
      build_path.write inserter.new(build_path.readlines, :after).call(content, pattern).join
      self
    end

    def insert_before pattern, content
      log_debug "Inserting content before pattern in: #{relative_build_path}"
      build_path.write inserter.new(build_path.readlines, :before).call(content, pattern).join
      self
    end

    def make_path
      log_info "Making: #{relative_build_path}"
      build_path.make_path
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
      log_info "Rendering: #{relative_build_path}"

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
      log_info "Running: #{command}"
      execute(*command)
      self
    rescue StandardError => error
      log_error error and self
    end

    def touch
      log_info "Touching: #{relative_build_path}"
      build_path.deep_touch
      self
    end

    private

    attr_reader :settings, :helpers

    def execute *command
      executor.capture2e(*command).then do |result, status|
        log_error result unless status.success?
      end
    end

    def inserter = helpers.fetch(__method__)

    def renderer = helpers.fetch(__method__).new(settings)

    def executor = helpers.fetch(__method__)

    def relative_build_path = build_path.relative_path_from(settings.target_root)

    def build_path
      pathway.end_path
             .gsub("%project_name%", settings.project_name)
             .sub("%project_path%", settings.project_path)
             .sub ".erb", ""
    end

    def pathway = settings.pathway

    def log_info(message) = logger.info { message }

    def log_debug(message) = logger.debug { message }

    def log_error(message) = logger.error { message }
  end
end
