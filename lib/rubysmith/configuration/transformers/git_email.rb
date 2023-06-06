# frozen_string_literal: true

require "dry/monads"
require "gitt"

module Rubysmith
  module Configuration
    # Dynamically adds Git email if defined.
    module Transformers
      include Dry::Monads[:result]

      GitEmail = lambda do |content, git: Gitt::Repository.new|
        return Dry::Monads::Success content if content[:author_email]

        git.get("user.email").fmap { |email| content.merge! author_email: email }
      end
    end
  end
end
