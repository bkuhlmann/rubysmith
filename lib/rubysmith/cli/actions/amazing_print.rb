# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Amazing Print flag.
      class AmazingPrint < Sod::Action
        include Import[:settings]

        description "Add Amazing Print gem."

        on "--[no-]amazing_print"

        default { Container[:settings].build_amazing_print }

        def call(boolean) = settings.build_amazing_print = boolean
      end
    end
  end
end
