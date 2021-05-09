# frozen_string_literal: true

require "refinements/pathnames"
require "open3"
require "logger"

module Rubysmith
  # :reek:TooManyMethods
  # Provides common functionality necessary for all builders.
  class Builder
    using Refinements::Pathnames

    LOGGER = Logger.new(STDOUT, formatter: ->(_severity, _at, _program, message) { "#{message}\n" })

    HELPERS = {
      inserter: Text::Inserter,
      renderer: Renderers::ERB,
      kernel: Open3,
      logger: LOGGER
    }.freeze

    def self.call(configuration, helpers: HELPERS) = new(configuration, helpers: helpers)

    def initialize configuration, helpers: HELPERS
      @configuration = configuration
      @helpers = helpers
    end

    def append content
      logger.info "Appending: #{relative_build_path}"
      build_path.rewrite { |body| body + content }
      self
    end

    def delete
      logger.info "Deleting: #{relative_build_path}"
      build_path.delete
      self
    end

    def insert_before pattern, content
      logger.info "Inserting content before pattern in: #{relative_build_path}"
      build_path.write inserter.new(build_path.readlines, :before).call(content, pattern).join
      self
    end

    def insert_after pattern, content
      logger.info "Inserting content after pattern in: #{relative_build_path}"
      build_path.write inserter.new(build_path.readlines, :after).call(content, pattern).join
      self
    end

    def permit mode
      logger.info "Changing permissions for: #{relative_build_path}"
      build_path.chmod mode
      self
    end

    def prepend content
      logger.info "Prepending content to: #{relative_build_path}"
      build_path.rewrite { |body| content + body }
      self
    end

    def rename name
      logger.info "Renaming: #{build_path.basename} to #{name}"
      build_path.rename build_path.parent.join(name)
      self
    end

    def render
      logger.info "Rendering: #{relative_build_path}"

      pathway.start_path.read.then do |content|
        build_path.make_ancestors.write renderer.call(content)
      end

      self
    end

    def replace pattern, content
      logger.info "Replacing content for patterns in: #{relative_build_path}"
      build_path.rewrite { |body| body.gsub pattern, content }
      self
    end

    def run *command
      logger.info "Running: #{command}"
      execute(*command)
      self
    rescue StandardError => error
      logger.error error and self
    end

    def touch
      logger.info "Touching: #{relative_build_path}"
      build_path.make_ancestors.touch
      self
    end

    private

    attr_reader :configuration, :helpers

    def execute *command
      kernel.capture2e(*command).then do |result, status|
        logger.error result unless status.success?
      end
    end

    def inserter = helpers.fetch(__method__)

    def renderer = helpers.fetch(__method__).new(configuration)

    def kernel = helpers.fetch(__method__)

    def logger = helpers.fetch(__method__)

    def relative_build_path = build_path.relative_path_from(configuration.build_root)

    def build_path
      pathway.end_path.gsub("%project_name%", configuration.project_name).sub ".erb", ""
    end

    def pathway = configuration.to_pathway
  end
end
