# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores citation flag.
      class Citation < Sod::Action
        include Import[:settings]

        description "Add citation documentation."

        on "--[no-]citation"

        default { Container[:settings].build_citation }

        def call(value = nil) = settings.build_citation = value
      end
    end
  end
end
