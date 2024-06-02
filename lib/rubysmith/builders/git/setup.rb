# frozen_string_literal: true

module Rubysmith
  module Builders
    module Git
      # Initializes project skeleton as a Git repository.
      class Setup < Abstract
        def call
          return settings unless settings.build_git

          builder.call(settings).run("git init", chdir: settings.project_name)
          settings
        end
      end
    end
  end
end
