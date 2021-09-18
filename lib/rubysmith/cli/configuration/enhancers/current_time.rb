# frozen_string_literal: true

require "refinements/structs"

module Rubysmith
  module CLI
    module Configuration
      module Enhancers
        # Adds current time to content.
        class CurrentTime
          using Refinements::Structs

          def initialize now = Time.now
            @now = now
          end

          def call(content) = content.merge(now: now)

          private

          attr_reader :now
        end
      end
    end
  end
end
