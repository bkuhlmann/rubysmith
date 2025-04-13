# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores monads flag.
      class Monads < Sod::Action
        include Dependencies[:settings]

        description "Add Dry Monads gem."

        on "--[no-]monads"

        default { Container[:settings].build_monads }

        def call(boolean) = settings.build_monads = boolean
      end
    end
  end
end
