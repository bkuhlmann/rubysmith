# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Developer Certificate of Origin flag.
      class DCOO < Sod::Action
        include Import[:settings]

        description "Add Developer Certificate of Origin documentation."

        on "--[no-]dcoo"

        default { Container[:settings].build_dcoo }

        def call(boolean) = settings.build_dcoo = boolean
      end
    end
  end
end
