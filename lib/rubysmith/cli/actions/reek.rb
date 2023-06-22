# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Reek flag.
      class Reek < Sod::Action
        include Import[:input]

        description "Add Reek gem."

        on "--[no-]reek"

        default { Container[:configuration].build_reek }

        def call(value = nil) = input.build_reek = value
      end
    end
  end
end
