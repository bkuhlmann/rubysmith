# frozen_string_literal: true

require "auto_injector"

module Rubysmith
  module CLI
    module Actions
      Import = AutoInjector[Container]
    end
  end
end
