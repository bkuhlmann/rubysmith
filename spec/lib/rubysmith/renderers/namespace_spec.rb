# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Renderers::Namespace do
  subject(:renderer) { described_class.new name }

  let(:name) { "Example" }

  let :content do
    "  def example_1\n" \
    "    1\n" \
    "  end\n\n" \
    "  def example_2\n" \
    "    2\n" \
    "  end\n"
  end

  describe "#call" do
    context "with single module" do
      let :expected_content do
        "module Example\n" \
        "  def example_1\n" \
        "    1\n" \
        "  end\n\n" \
        "  def example_2\n" \
        "    2\n" \
        "  end\n" \
        "end"
      end

      it "renders single module" do
        expect(renderer.call(content)).to eq(expected_content)
      end
    end

    context "with multiple modules" do
      let(:name) { "One::Two::Three" }

      let :expected_content do
        "module One\n" \
        "  module Two\n" \
        "    module Three\n" \
        "      def example_1\n" \
        "        1\n" \
        "      end\n\n" \
        "      def example_2\n" \
        "        2\n" \
        "      end\n" \
        "    end\n" \
        "  end\n" \
        "end"
      end

      it "renders nested modules" do
        expect(renderer.call(content)).to eq(expected_content)
      end
    end

    context "with leading carriage return for content" do
      let :content do
        "\n  def example_1\n" \
        "    1\n" \
        "  end\n\n" \
        "  def example_2\n" \
        "    2\n" \
        "  end\n"
      end

      let :expected_content do
        "module Example\n" \
        "  def example_1\n" \
        "    1\n" \
        "  end\n\n" \
        "  def example_2\n" \
        "    2\n" \
        "  end\n" \
        "end"
      end

      it "removes carriage return" do
        expect(renderer.call(content)).to eq(expected_content)
      end
    end
  end
end
