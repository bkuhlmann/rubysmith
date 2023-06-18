# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Debug flag.
      class Debug < Sod::Action
        include Import[:input]

        description "Add Debug gem."

        on "--[no-]debug"

        default { Container[:configuration].build_debug }

        def call(value = default) = input.build_debug = value
      end
    end
  end
end
