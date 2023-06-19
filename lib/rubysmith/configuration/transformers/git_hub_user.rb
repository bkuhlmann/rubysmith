# frozen_string_literal: true

require "dry/monads"

module Rubysmith
  module Configuration
    module Transformers
      # Dynamically adds GitHub user if user is defined.
      class GitHubUser
        include Import[:git]
        include Dry::Monads[:result]

        def call(content) = content[:git_hub_user] ? Success(content) : user_or(content)

        private

        def user_or content
          git.get("github.user", nil)
             .fmap { |user| user ? content.merge!(git_hub_user: user) : content }
             .or { Success content }
        end
      end
    end
  end
end
