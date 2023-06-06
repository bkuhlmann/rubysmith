# frozen_string_literal: true

require "dry/monads"
require "gitt"

module Rubysmith
  module Configuration
    # Dynamically adds Git user if defined.
    module Transformers
      include Dry::Monads[:result]

      GitUser = lambda do |content, git: Gitt::Repository.new|
        if content[:author_given_name] || content[:author_family_name]
          Dry::Monads::Success content
        else
          git.get("user.name").fmap do |name|
            first, last = String(name).split
            content.merge author_given_name: first, author_family_name: last
          end
        end
      end
    end
  end
end
