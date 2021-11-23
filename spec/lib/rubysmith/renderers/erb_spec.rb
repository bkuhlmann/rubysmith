# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Renderers::ERB do
  subject(:renderer) { described_class.new test_configuration }

  include_context "with application container"

  describe "#call" do
    let(:test_configuration) { configuration.minimize }

    it "answers result" do
      expect(renderer.call("Name: <%= configuration.project_name %>.")).to eq("Name: test.")
    end

    it "trims conditional new lines" do
      content = <<~TEMPLATE
        <% if configuration.project_name == "invalid" %>
          This is not valid.
        <% end %>
      TEMPLATE

      expect(renderer.call(content)).to eq("")
    end

    context "with content before namespace" do
      let(:test_configuration) { configuration.minimize.with project_name: "example" }

      let :content do
        <<~CONTENT
          # Before.
          <% namespace %>
        CONTENT
      end

      it "renders content plus namespace" do
        expectation = renderer.call content

        expect(expectation).to eq(<<~PROOF)
          # Before.
          module Example
          end
        PROOF
      end
    end

    context "with single filled namespace" do
      let(:test_configuration) { configuration.minimize.with project_name: "example" }

      let :content do
        <<~CONTENT
          <% namespace do %>
            # Implementation.
          <% end %>
        CONTENT
      end

      it "renders single namespace" do
        expectation = renderer.call content

        expect(expectation).to eq(<<~PROOF)
          module Example
            # Implementation.
          end
        PROOF
      end
    end

    context "with single empty namespace" do
      let(:test_configuration) { configuration.minimize.with project_name: "example" }

      let(:content) { "<% namespace %>" }

      it "renders single namespace" do
        expectation = renderer.call content

        expect(expectation).to eq(<<~PROOF)
          module Example
          end
        PROOF
      end
    end

    context "with multiple empty namespaces" do
      let :test_configuration do
        configuration.minimize.with project_name: "example-one-two"
      end

      let(:content) { "<% namespace %>" }

      let :proof do
        <<~PROOF
          module Example
            module One
              module Two
              end
            end
          end
        PROOF
      end

      it "renders multiple namespaces" do
        expectation = renderer.call content
        expect(expectation).to eq(proof)
      end
    end

    context "with multiple filled namespaces" do
      let :test_configuration do
        configuration.minimize.with project_name: "example-one-two"
      end

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

      it "renders multiple namespaces" do
        expectation = renderer.call content
        expect(expectation).to eq(proof)
      end
    end
  end
end
