# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Debug flag.
      class Debug < Sod::Action
        include Dependencies[:settings]

        description "Add Debug gem."

        on "--[no-]debug"

        default { Container[:settings].build_debug }

        def call(boolean) = settings.build_debug = boolean
      end
    end
  end
end
