# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores citation flag.
      class Citation < Sod::Action
        include Import[:input]

        using ::Refinements::Structs

        description "Add citation documentation."

        on "--[no-]citation"

        default { Container[:configuration].build_citation }

        def call(value = default) = input.merge!(build_citation: value)
      end
    end
  end
end
