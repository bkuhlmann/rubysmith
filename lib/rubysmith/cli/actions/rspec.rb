# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores RSpec flag.
      class RSpec < Sod::Action
        include Import[:settings]

        description "Add RSpec gem."

        on "--[no-]rspec"

        default { Container[:settings].build_rspec }

        def call(value = nil) = settings.build_rspec = value
      end
    end
  end
end
