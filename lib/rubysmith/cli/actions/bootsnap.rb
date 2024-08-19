# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Bootsnap flag.
      class Bootsnap < Sod::Action
        include Import[:settings]

        description "Add Bootsnap gem."

        on "--[no-]bootsnap"

        default { Container[:settings].build_bootsnap }

        def call(boolean) = settings.build_bootsnap = boolean
      end
    end
  end
end
