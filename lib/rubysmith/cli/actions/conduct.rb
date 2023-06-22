# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores conduct flag.
      class Conduct < Sod::Action
        include Import[:input]

        description "Add code of conduct documentation."

        on "--[no-]conduct"

        default { Container[:configuration].build_conduct }

        def call(value = nil) = input.build_conduct = value
      end
    end
  end
end
