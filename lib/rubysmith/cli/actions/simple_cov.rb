# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores SimpleCov flag.
      class SimpleCov < Sod::Action
        include Import[:settings]

        description "Add SimpleCov gem."

        on "--[no-]simple_cov"

        default { Container[:settings].build_simple_cov }

        def call(boolean) = settings.build_simple_cov = boolean
      end
    end
  end
end
