# frozen_string_literal: true

require "dry/monads"

module Rubysmith
  module Configuration
    # Adds current time to content.
    module Transformers
      include Dry::Monads[:result]

      CurrentTime = lambda do |content, at: Time.now|
        content.fetch(:now) { at }
               .then { |now| content.merge! now: }
               .then { |updated_content| Dry::Monads::Success updated_content }
      end
    end
  end
end
