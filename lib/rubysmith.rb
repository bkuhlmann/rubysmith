# frozen_string_literal: true

require "rubysmith/identity"
require "rubysmith/pathway"
require "rubysmith/realm"
require "rubysmith/renderers/namespace"
require "rubysmith/renderers/erb"
require "rubysmith/text/inserter"
require "rubysmith/builder"
require "rubysmith/builders/core"
require "rubysmith/builders/documentation"
require "rubysmith/builders/git/setup"
require "rubysmith/builders/git/commit"
require "rubysmith/builders/bundler"
require "rubysmith/builders/rake"
require "rubysmith/builders/console"
require "rubysmith/builders/setup"
require "rubysmith/builders/guard"
require "rubysmith/builders/reek"
require "rubysmith/builders/rspec/context"
require "rubysmith/builders/rspec/helper"
require "rubysmith/builders/pragma"
require "rubysmith/builders/rubocop/setup"
require "rubysmith/builders/rubocop/formatter"
require "rubysmith/builders/ruby_critic"
require "rubysmith/cli/parsers"
require "rubysmith/cli/parsers/core"
require "rubysmith/cli/parsers/build"
require "rubysmith/cli/parsers/assembler"
require "rubysmith/cli/processors/config"
require "rubysmith/cli/processors/build"
require "rubysmith/cli/configuration"
require "rubysmith/cli/shell"
