# frozen_string_literal: true

require "gitt"
require "refinements/strings"
require "refinements/structs"

module Rubysmith
  module Configuration
    module Enhancers
      # Dynamically adds GitHub user if user is defined.
      class GitHubUser
        using Refinements::Strings
        using Refinements::Structs

        def initialize git: Gitt::Repository.new
          @git = git
        end

        def call content
          String(content.git_hub_user).blank? ? content.merge(git_hub_user: user) : content
        end

        private

        attr_reader :git

        def user = git.get "github.user"
      end
    end
  end
end
