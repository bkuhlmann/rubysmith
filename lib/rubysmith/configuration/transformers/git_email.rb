# frozen_string_literal: true

require "dry/monads"

module Rubysmith
  module Configuration
    module Transformers
      # Dynamically adds Git email if defined.
      class GitEmail
        include Dependencies[:git]
        include Dry::Monads[:result]

        def initialize(key = :author_email, **)
          @key = key
          super(**)
        end

        def call(attributes) = attributes[key] ? Success(attributes) : email_or(attributes)

        private

        attr_reader :key

        def email_or attributes
          git.get("user.email", nil)
             .fmap { |value| value ? attributes.merge!(key => value) : attributes }
             .or { Success attributes }
        end
      end
    end
  end
end
