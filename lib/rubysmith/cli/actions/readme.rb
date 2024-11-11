# frozen_string_literal: true

require "sod"

module Rubysmith
  module CLI
    module Actions
      # Stores readme flag.
      class Readme < Sod::Action
        include Dependencies[:settings]

        description "Add readme documentation."

        on "--[no-]readme"

        default { Container[:settings].build_readme }

        def call(boolean) = settings.build_readme = boolean
      end
    end
  end
end
