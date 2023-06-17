# frozen_string_literal: true

require "dry/monads"

module Rubysmith
  module Configuration
    module Transformers
      # Dynamically adds GitHub user if user is defined.
      class GitHubUser
        include Import[:git]
        include Dry::Monads[:result]

        def call content
          return Success content if content[:git_hub_user]

          git.get("github.user").fmap { |user| content.merge! git_hub_user: user }
        end
      end
    end
  end
end
