# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores RSpec flag.
      class RSpec < Sod::Action
        include Dependencies[:settings]

        description "Add RSpec gem."

        on "--[no-]rspec"

        default { Container[:settings].build_rspec }

        def call(boolean) = settings.build_rspec = boolean
      end
    end
  end
end
