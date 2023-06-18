# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores SimpleCov flag.
      class SimpleCov < Sod::Action
        include Import[:input]

        description "Add SimpleCov gem."

        on "--[no-]simple_cov"

        default { Container[:configuration].build_simple_cov }

        def call(value = default) = input.build_simple_cov = value
      end
    end
  end
end
