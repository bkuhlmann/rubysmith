# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Amazing Print flag.
      class AmazingPrint < Sod::Action
        include Import[:input]

        using ::Refinements::Structs

        description "Add Amazing Print gem."

        on "--[no-]amazing_print"

        default { Container[:configuration].build_amazing_print }

        def call(value = default) = input.merge!(build_amazing_print: value)
      end
    end
  end
end
