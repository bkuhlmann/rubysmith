# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores IRB Kit flag.
      class IRBKit < Sod::Action
        include Import[:settings]

        description "Add IRB Kit gem."

        on "--[no-]irb-kit"

        default { Container[:settings].build_irb_kit }

        def call(value = nil) = settings.build_irb_kit = value
      end
    end
  end
end
