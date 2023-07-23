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

        def call(content) = content[key] ? Success(content) : user_or(content)

        private

        attr_reader :key

        def user_or content
          git.get("github.user", nil)
             .fmap { |value| value ? content.merge!(key => value) : content }
             .or { Success content }
        end
      end
    end
  end
end
