# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Reek flag.
      class Reek < Sod::Action
        include Import[:settings]

        description "Add Reek gem."

        on "--[no-]reek"

        default { Container[:settings].build_reek }

        def call(boolean) = settings.build_reek = boolean
      end
    end
  end
end
