# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Zeitwerk flag.
      class Zeitwerk < Sod::Action
        include Dependencies[:settings]

        description "Add Zeitwerk gem."

        on "--[no-]zeitwerk"

        default { Container[:settings].build_zeitwerk }

        def call(boolean) = settings.build_zeitwerk = boolean
      end
    end
  end
end
