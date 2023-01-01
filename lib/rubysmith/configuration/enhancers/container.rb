# frozen_string_literal: true

require "dry/container"

module Rubysmith
  module Configuration
    module Enhancers
      # Provides a container of enhancers for injection into other objects.
      module Container
        extend Dry::Container::Mixin

        register(:current_time) { Enhancers::CurrentTime }
        register(:git_hub_user) { Enhancers::GitHubUser }
        register(:git_email) { Enhancers::GitEmail }
        register(:git_user) { Enhancers::GitUser }
        register(:template_root) { Enhancers::TemplateRoot }
      end
    end
  end
end
