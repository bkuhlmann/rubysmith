# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Renderers::ERB, :realm do
  subject(:renderer) { described_class.new realm }

  describe "#call" do
    let(:realm) { default_realm }

    it "answers result" do
      expect(renderer.call("Name: <%= realm.project_name %>.")).to eq("Name: test.")
    end

    it "trims conditional new lines" do
      content = <<~TEMPLATE
        <% if realm.project_name == "invalid" %>
          This is not valid.
        <% end %>
      TEMPLATE

      expect(renderer.call(content)).to eq("")
    end

    context "with single namespace" do
      let(:realm) { default_realm.with project_name: "example" }

      let :content do
        <<~CONTENT
          <% namespace do %>
            # Implementation.
          <% end %>
        CONTENT
      end

      let :proof do
        <<~PROOF
          module Example
            # Implementation.
          end
        PROOF
      end

      it "renders single namespace" do
        expectation = renderer.call content
        expect(expectation).to eq(proof.chomp)
      end
    end

    context "with multiple namespaces" do
      let(:realm) { default_realm.with project_name: "example-one-two" }

      let :content do
        <<~CONTENT
          <% namespace do %>
            # Implementation.
          <% end %>
        CONTENT
      end

      let :proof do
        <<~PROOF
          module Example
            module One
              module Two
                # Implementation.
              end
            end
          end
        PROOF
      end

      it "renders single namespace" do
        expectation = renderer.call content
        expect(expectation).to eq(proof.chomp)
      end
    end
  end
end
