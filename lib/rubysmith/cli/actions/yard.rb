# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Yard flag.
      class Yard < Sod::Action
        include Import[:input]

        description "Add Yard gem."

        on "--[no-]yard"

        default { Container[:configuration].build_yard }

        def call(value = default) = input.build_yard = value
      end
    end
  end
end
