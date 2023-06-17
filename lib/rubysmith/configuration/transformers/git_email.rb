# frozen_string_literal: true

require "dry/monads"

module Rubysmith
  module Configuration
    module Transformers
      # Dynamically adds Git email if defined.
      class GitEmail
        include Import[:git]
        include Dry::Monads[:result]

        def call content
          return Success content if content[:author_email]

          git.get("user.email").fmap { |email| content.merge! author_email: email }
        end
      end
    end
  end
end
