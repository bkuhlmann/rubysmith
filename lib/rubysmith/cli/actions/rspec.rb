# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores RSpec flag.
      class RSpec < Sod::Action
        include Import[:input]

        using ::Refinements::Structs

        description "Add RSpec gem."

        on "--[no-]rspec"

        default { Container[:configuration].build_rspec }

        def call(value = default) = input.merge!(build_rspec: value)
      end
    end
  end
end
