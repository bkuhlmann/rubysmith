# frozen_string_literal: true

RSpec::Matchers.define :match_cli_version do
  expected = /Rubysmith\s\d+\.\d+\.\d+/

  match { |actual| actual.match? expected }

  description { "match /#{expected.source}/" }
end
