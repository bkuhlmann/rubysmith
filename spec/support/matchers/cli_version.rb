# frozen_string_literal: true

RSpec::Matchers.define :match_cli_version do
  expected = /Rubysmith\s\d+\.\d+\.\d+/

  match do |actual|
    actual.match? expected
  end

  description do
    "match /#{expected.source}/"
  end
end
