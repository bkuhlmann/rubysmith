# frozen_string_literal: true

require "refinements/structs"

module Rubysmith
  module Configuration
    # Adds current time to content.
    module Transformers
      using Refinements::Structs

      CurrentTime = -> content, at: Time.now { content.merge now: at }
    end
  end
end
