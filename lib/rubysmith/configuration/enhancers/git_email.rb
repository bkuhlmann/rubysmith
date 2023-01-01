# frozen_string_literal: true

require "gitt"
require "refinements/strings"
require "refinements/structs"

module Rubysmith
  module Configuration
    # Dynamically adds Git email if defined.
    module Enhancers
      using Refinements::Strings
      using Refinements::Structs

      GitEmail = lambda do |content, git: Gitt::Repository.new|
        return content unless String(content.author_email).blank?

        content.merge author_email: git.get("user.email").value_or("")
      end
    end
  end
end
