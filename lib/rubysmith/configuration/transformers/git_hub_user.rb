# frozen_string_literal: true

require "dry/monads"

module Rubysmith
  module Configuration
    module Transformers
      # Dynamically updates repository handle if GitHub user is defined.
      class GitHubUser
        include Dependencies[:git]
        include Dry::Monads[:result]

        def initialize(key = :repository_handle, **)
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
