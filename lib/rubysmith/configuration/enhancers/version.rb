# frozen_string_literal: true

require "refinements/structs"

module Rubysmith
  module Configuration
    module Enhancers
      # Adds this gem's version to content.
      class Version
        using Refinements::Structs

        def initialize version = Identity::VERSION_LABEL
          @version = version
        end

        def call(content) = content.merge(version: version)

        private

        attr_reader :version
      end
    end
  end
end
