# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Debug flag.
      class Debug < Sod::Action
        include Import[:input]

        using ::Refinements::Structs

        description "Add Debug gem."

        on "--[no-]debug"

        default { Container[:configuration].build_debug }

        def call(value = default) = input.merge!(build_debug: value)
      end
    end
  end
end
