# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Renderers::Namespace do
  subject(:renderer) { described_class.new name }

  let(:name) { "Example" }

  let :content do
    # The method body double indentation is necessary due to squiggly heredoc syntax.
    <<~BODY
      def example_1
          1
      end

      def example_2
          2
      end
    BODY
  end

  describe "#call" do
    context "with single empty module" do
      let :expected_content do
        <<~CONTENT
          module Example
          end
        CONTENT
      end

      it "renders single module" do
        expect(renderer.call).to eq(expected_content)
      end
    end

    context "with single filled module" do
      let :expected_content do
        <<~CONTENT
          module Example
            def example_1
              1
            end

            def example_2
              2
            end
          end
        CONTENT
      end

      it "renders single module" do
        expect(renderer.call(content)).to eq(expected_content)
      end
    end

    context "with multiple empty modules" do
      let(:name) { "One::Two::Three" }

      let :expected_content do
        <<~CONTENT
          module One
            module Two
              module Three
              end
            end
          end
        CONTENT
      end

      it "renders nested modules" do
        expect(renderer.call).to eq(expected_content)
      end
    end

    context "with multiple filled modules" do
      let(:name) { "One::Two::Three" }

      let :expected_content do
        <<~CONTENT
          module One
            module Two
              module Three
                def example_1
                  1
                end

                def example_2
                  2
                end
              end
            end
          end
        CONTENT
      end

      it "renders nested modules" do
        expect(renderer.call(content)).to eq(expected_content)
      end
    end

    context "with leading carriage return for content" do
      # The method body double indentation is necessary due to squiggly heredoc syntax.
      let :content do
        <<~CONTENT

          def example_1
              1
          end

          def example_2
              2
          end
        CONTENT
      end

      let :expected_content do
        <<~CONTENT
          module Example
            def example_1
              1
            end\n
            def example_2
              2
            end
          end
        CONTENT
      end

      it "removes carriage return" do
        expect(renderer.call(content)).to eq(expected_content)
      end
    end
  end
end
