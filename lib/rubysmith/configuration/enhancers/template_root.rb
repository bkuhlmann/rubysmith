# frozen_string_literal: true

module Rubysmith
  module Configuration
    module Enhancers
      # Prepends template roots to existing content.
      TemplateRoot = lambda do |content, overrides: Pathname(__dir__).join("../../templates")|
        content.add_template_roots(*Array(overrides))
      end
    end
  end
end
