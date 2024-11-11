# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores funding flag.
      class Funding < Sod::Action
        include Dependencies[:settings]

        description "Add GitHub funding."

        on "--[no-]funding"

        default { Container[:settings].build_funding }

        def call(boolean) = settings.build_funding = boolean
      end
    end
  end
end
