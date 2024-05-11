# frozen_string_literal: true

require "dry/monads"

module Rubysmith
  module Configuration
    # Adds current time.
    module Transformers
      include Dry::Monads[:result]

      CurrentTime = lambda do |attributes, key = :now, at: Time.now|
        attributes.fetch(key) { at }
                  .then { |value| attributes.merge! key => value }
                  .then { |updated_attributes| Dry::Monads::Success updated_attributes }
      end
    end
  end
end
