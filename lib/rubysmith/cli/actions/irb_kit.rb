# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores IRB Kit flag.
      class IRBKit < Sod::Action
        include Dependencies[:settings]

        description "Add IRB Kit gem."

        on "--[no-]irb-kit"

        default { Container[:settings].build_irb_kit }

        def call(boolean) = settings.build_irb_kit = boolean
      end
    end
  end
end
