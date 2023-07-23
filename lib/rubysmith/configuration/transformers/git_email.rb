# frozen_string_literal: true

require "dry/monads"

module Rubysmith
  module Configuration
    module Transformers
      # Dynamically adds Git email if defined.
      class GitEmail
        include Import[:git]
        include Dry::Monads[:result]

        def initialize(key = :author_email, **)
          @key = key
          super(**)
        end

        def call(content) = content[key] ? Success(content) : email_or(content)

        private

        attr_reader :key

        def email_or content
          git.get("user.email", nil)
             .fmap { |value| value ? content.merge!(key => value) : content }
             .or { Success content }
        end
      end
    end
  end
end
