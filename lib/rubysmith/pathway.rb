# frozen_string_literal: true

require "refinements/pathnames"

module Rubysmith
  # Represents a pathway which has source start and destination end.
  Pathway = Struct.new :start_root, :start_path, :end_root, keyword_init: true do
    using Refinements::Pathnames

    # :reek:TooManyStatements
    def initialize *arguments
      super
      each_pair { |key, value| self[key] = Pathname value }
      self[:start_path] = start_path.absolute? ? start_path : start_root.join(start_path)
      freeze
    end

    def with(attributes) = self.class.new(to_h.merge(attributes))

    def end_path = end_root.join(from_parent, start_path.basename)

    def partial? = start_path.basename.fnmatch?("_*")

    private

    def from_parent
      return end_root.join start_path.parent if start_path.relative?

      start_path.relative_parent start_root
    end
  end
end
