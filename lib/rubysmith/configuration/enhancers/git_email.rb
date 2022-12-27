# frozen_string_literal: true

require "gitt"
require "refinements/strings"
require "refinements/structs"

module Rubysmith
  module Configuration
    module Enhancers
      # Dynamically adds Git email if defined.
      class GitEmail
        using Refinements::Strings
        using Refinements::Structs

        def initialize git: Gitt::Repository.new
          @git = git
        end

        def call content
          String(content.author_email).blank? ? content.merge(author_email: email) : content
        end

        private

        attr_reader :git

        def email = git.get "user.email", "TODO"
      end
    end
  end
end
