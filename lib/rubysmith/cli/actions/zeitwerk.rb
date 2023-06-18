# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Zeitwerk flag.
      class Zeitwerk < Sod::Action
        include Import[:input]

        description "Add Zeitwerk gem."

        on "--[no-]zeitwerk"

        default { Container[:configuration].build_zeitwerk }

        def call(value = default) = input.build_zeitwerk = value
      end
    end
  end
end
