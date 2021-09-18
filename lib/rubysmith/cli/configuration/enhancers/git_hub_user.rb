# frozen_string_literal: true

require "git_plus"
require "refinements/strings"
require "refinements/structs"

module Rubysmith
  module CLI
    module Configuration
      module Enhancers
        # Dynamically adds GitHub user if user is defined.
        class GitHubUser
          using Refinements::Strings
          using Refinements::Structs

          def initialize repository: GitPlus::Repository.new
            @repository = repository
          end

          def call content
            String(content.git_hub_user).blank? ? content.merge(git_hub_user: user) : content
          end

          private

          attr_reader :repository

          def user = repository.config_get("github.user")
        end
      end
    end
  end
end
