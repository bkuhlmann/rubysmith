# frozen_string_literal: true

require "git_plus"
require "refinements/strings"
require "refinements/structs"

module Rubysmith
  module Configuration
    module Enhancers
      # Dynamically adds Git email if defined.
      class GitEmail
        using Refinements::Strings
        using Refinements::Structs

        def initialize repository: GitPlus::Repository.new
          @repository = repository
        end

        def call content
          String(content.author_email).blank? ? content.merge(author_email: email) : content
        end

        private

        attr_reader :repository

        def email = repository.config_get("user.email")
      end
    end
  end
end
