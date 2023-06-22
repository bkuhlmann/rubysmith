# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores RSpec flag.
      class RSpec < Sod::Action
        include Import[:input]

        description "Add RSpec gem."

        on "--[no-]rspec"

        default { Container[:configuration].build_rspec }

        def call(value = nil) = input.build_rspec = value
      end
    end
  end
end
