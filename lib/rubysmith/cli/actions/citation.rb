# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores citation flag.
      class Citation < Sod::Action
        include Dependencies[:settings]

        description "Add citation documentation."

        on "--[no-]citation"

        default { Container[:settings].build_citation }

        def call(boolean) = settings.build_citation = boolean
      end
    end
  end
end
