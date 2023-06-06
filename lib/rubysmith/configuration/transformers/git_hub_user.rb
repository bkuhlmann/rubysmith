# frozen_string_literal: true

require "dry/monads"
require "gitt"

module Rubysmith
  module Configuration
    # Dynamically adds GitHub user if user is defined.
    module Transformers
      include Dry::Monads[:result]

      GitHubUser = lambda do |content, git: Gitt::Repository.new|
        return Dry::Monads::Success content if content[:git_hub_user]

        git.get("github.user").fmap { |user| content.merge! git_hub_user: user }
      end
    end
  end
end
