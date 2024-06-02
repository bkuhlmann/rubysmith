# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Debug flag.
      class Debug < Sod::Action
        include Import[:settings]

        description "Add Debug gem."

        on "--[no-]debug"

        default { Container[:settings].build_debug }

        def call(value = nil) = settings.build_debug = value
      end
    end
  end
end
