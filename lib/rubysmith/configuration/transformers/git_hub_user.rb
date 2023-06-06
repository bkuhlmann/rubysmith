# frozen_string_literal: true

require "gitt"
require "refinements/strings"
require "refinements/structs"

module Rubysmith
  module Configuration
    # Dynamically adds GitHub user if user is defined.
    module Transformers
      using Refinements::Strings
      using Refinements::Structs

      GitHubUser = lambda do |content, git: Gitt::Repository.new|
        return content unless String(content.git_hub_user).blank?

        content.merge git_hub_user: git.get("github.user").value_or("default")
      end
    end
  end
end
