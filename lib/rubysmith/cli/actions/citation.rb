# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores citation flag.
      class Citation < Sod::Action
        include Import[:input]

        description "Add citation documentation."

        on "--[no-]citation"

        default { Container[:configuration].build_citation }

        def call(value = nil) = input.build_citation = value
      end
    end
  end
end
