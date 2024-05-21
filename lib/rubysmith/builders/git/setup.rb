# frozen_string_literal: true

module Rubysmith
  module Builders
    module Git
      # Initializes project skeleton as a Git repository.
      class Setup < Abstract
        def call
          return configuration unless configuration.build_git

          builder.call(configuration).run("git init", chdir: configuration.project_name)
          configuration
        end
      end
    end
  end
end
