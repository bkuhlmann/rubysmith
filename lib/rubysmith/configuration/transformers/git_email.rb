# frozen_string_literal: true

require "dry/monads"

module Rubysmith
  module Configuration
    module Transformers
      # Dynamically adds Git email if defined.
      class GitEmail
        include Import[:git]
        include Dry::Monads[:result]

        def call(content) = content[:author_email] ? Success(content) : email_or(content)

        private

        def email_or content
          git.get("user.email", nil)
             .fmap { |email| email ? content.merge!(author_email: email) : content }
             .or { Success content }
        end
      end
    end
  end
end
