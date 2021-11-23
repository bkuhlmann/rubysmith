# frozen_string_literal: true

require "git_plus"
require "refinements/strings"
require "refinements/structs"

module Rubysmith
  module Configuration
    module Enhancers
      # Dynamically adds Git user if defined.
      class GitUser
        using Refinements::Strings
        using Refinements::Structs

        def initialize repository: GitPlus::Repository.new
          @repository = repository
        end

        def call(content) = String(content.author_name).blank? ? content.merge(**user) : content

        private

        attr_reader :repository

        def user
          repository.config_get("user.name")
                    .then { |name| String(name).split }
                    .then { |first, last| {author_given_name: first, author_family_name: last} }
        end
      end
    end
  end
end
