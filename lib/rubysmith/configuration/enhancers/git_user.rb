# frozen_string_literal: true

require "gitt"
require "refinements/strings"
require "refinements/structs"

module Rubysmith
  module Configuration
    module Enhancers
      # Dynamically adds Git user if defined.
      class GitUser
        using Refinements::Strings
        using Refinements::Structs

        def initialize git: Gitt::Repository.new
          @git = git
        end

        def call(content) = String(content.author_name).blank? ? content.merge(**user) : content

        private

        attr_reader :git

        def user
          git.get("user.name")
             .value_or("")
             .then { |name| String(name).split }
             .then { |first, last| {author_given_name: first, author_family_name: last} }
        end
      end
    end
  end
end
