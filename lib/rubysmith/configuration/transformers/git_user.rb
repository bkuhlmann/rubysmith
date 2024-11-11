# frozen_string_literal: true

require "dry/monads"

module Rubysmith
  module Configuration
    module Transformers
      # Dynamically adds Git user if defined.
      class GitUser
        include Dependencies[:git]
        include Dry::Monads[:result]

        def call attributes
          if attributes[:author_given_name] || attributes[:author_family_name]
            Success attributes
          else
            name_or attributes
          end
        end

        private

        def name_or(attributes) = split(attributes).or { Success attributes }

        def split attributes
          git.get("user.name", nil).fmap do |name|
            next attributes unless name

            first, last = String(name).split
            attributes.merge! author_given_name: first, author_family_name: last
          end
        end
      end
    end
  end
end
