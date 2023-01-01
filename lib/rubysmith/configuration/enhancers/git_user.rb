# frozen_string_literal: true

require "gitt"
require "refinements/strings"
require "refinements/structs"

module Rubysmith
  module Configuration
    # Dynamically adds Git user if defined.
    module Enhancers
      using Refinements::Strings
      using Refinements::Structs

      GitUser = lambda do |content, git: Gitt::Repository.new|
        return content unless String(content.author_name).blank?

        git.get("user.name")
           .value_or("")
           .then { |name| String(name).split }
           .then { |first, last| {author_given_name: first, author_family_name: last} }
           .then { |user| content.merge(**user) }
      end
    end
  end
end
