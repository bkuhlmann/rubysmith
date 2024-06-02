# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Zeitwerk flag.
      class Zeitwerk < Sod::Action
        include Import[:settings]

        description "Add Zeitwerk gem."

        on "--[no-]zeitwerk"

        default { Container[:settings].build_zeitwerk }

        def call(value = nil) = settings.build_zeitwerk = value
      end
    end
  end
end
