# frozen_string_literal: true

require "dry/monads"

module Rubysmith
  module Configuration
    # Sets target root which defaults to current directory when key is missing.
    module Transformers
      include Dry::Monads[:result]

      TargetRoot = lambda do |attributes, key = :target_root, path: Pathname.pwd|
        attributes.fetch(:target_root) { path }
                  .then { |value| attributes.merge! key => value }
                  .then { |updated_attributes| Dry::Monads::Success updated_attributes }
      end
    end
  end
end
