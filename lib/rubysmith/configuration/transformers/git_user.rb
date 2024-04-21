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

          name_or content
        end

        private

        def name_or(content) = split(content).or { Success content }

        def split content
          git.get("user.name", nil).fmap do |name|
            next content unless name

            first, last = String(name).split
            content.merge!(author_given_name: first, author_family_name: last).compress
          end
        end
      end
    end
  end
end
