# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Processors::Config do
  subject(:processor) { described_class.new }

  include_context "with application container"

  describe "#call" do
    it "edits configuration" do
      processor.call :edit
      expect(kernel).to have_received(:system).with(include("EDITOR"))
    end

    it "views configuration" do
      processor.call :view
      expect(kernel).to have_received(:system).with(include("cat"))
    end

    it "fails with invalid configuration" do
      expectation = proc { processor.call :bogus }
      expect(&expectation).to raise_error(StandardError, /Invalid configuration selection: bogus./)
    end
  end
end
