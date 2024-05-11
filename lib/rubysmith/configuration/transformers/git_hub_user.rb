# frozen_string_literal: true

require "dry/monads"

module Rubysmith
  module Configuration
    module Transformers
      # Dynamically adds GitHub user if user is defined.
      class GitHubUser
        include Import[:git]
        include Dry::Monads[:result]

        def initialize(key = :git_hub_user, **)
          @key = key
          super(**)
        end

        def call(attributes) = attributes[key] ? Success(attributes) : user_or(attributes)

        private

        attr_reader :key

        def user_or attributes
          git.get("github.user", nil)
             .fmap { |value| value ? attributes.merge!(key => value) : attributes }
             .or { Success attributes }
        end
      end
    end
  end
end
