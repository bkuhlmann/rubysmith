# frozen_string_literal: true

require "dry/monads"

module Rubysmith
  module Configuration
    module Transformers
      # Dynamically adds Git user if defined.
      class GitUser
        include Import[:git]
        include Dry::Monads[:result]

        def call content
          return Success content if content[:author_given_name] || content[:author_family_name]

          git.get("user.name").fmap do |name|
            first, last = String(name).split
            content.merge author_given_name: first, author_family_name: last
          end
        end
      end
    end
  end
end
