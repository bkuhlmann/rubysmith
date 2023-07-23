# frozen_string_literal: true

require "dry/monads"

module Rubysmith
  module Configuration
    # Sets target root which defaults to current directory when key is missing.
    module Transformers
      include Dry::Monads[:result]

      TargetRoot = lambda do |content, key = :target_root, path: Pathname.pwd|
        content.fetch(:target_root) { path }
               .then { |value| content.merge! key => value }
               .then { |updated_content| Dry::Monads::Success updated_content }
      end
    end
  end
end
