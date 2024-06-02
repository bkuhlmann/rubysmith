# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores Repl Type Completor flag.
      class RTC < Sod::Action
        include Import[:settings]

        description "Add Repl Type Completor gem."

        on "--[no-]rtc"

        default { Container[:settings].build_rtc }

        def call(value = nil) = settings.build_rtc = value
      end
    end
  end
end
