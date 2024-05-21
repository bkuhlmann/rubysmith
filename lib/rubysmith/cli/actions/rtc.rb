# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Repl Type Completor flag.
      class RTC < Sod::Action
        include Import[:input]

        description "Add Repl Type Completor gem."

        on "--[no-]rtc"

        default { Container[:configuration].build_rtc }

        def call(value = nil) = input.build_rtc = value
      end
    end
  end
end
