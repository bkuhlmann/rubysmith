# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Zeitwerk flag.
      class Zeitwerk < Sod::Action
        include Import[:inputs]

        using ::Refinements::Structs

        description "Add Zeitwerk gem."

        on "--[no-]zeitwerk"

        default { Container[:configuration].build_zeitwerk }

        def call(value = default) = inputs.merge!(build_zeitwerk: value)
      end
    end
  end
end
