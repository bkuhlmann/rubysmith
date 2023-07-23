# frozen_string_literal: true

require "dry/monads"

module Rubysmith
  module Configuration
    # Adds current time to content.
    module Transformers
      include Dry::Monads[:result]

      CurrentTime = lambda do |content, key = :now, at: Time.now|
        content.fetch(key) { at }
               .then { |value| content.merge! key => value }
               .then { |updated_content| Dry::Monads::Success updated_content }
      end
    end
  end
end
