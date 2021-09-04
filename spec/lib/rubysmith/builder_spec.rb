# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builder do
  subject :builder do
    described_class.new configuration,
                        helpers: described_class::HELPERS.merge(logger: Logger.new(output_buffer))
  end

  include_context "with temporary directory"

  using Refinements::Pathnames
  using Refinements::StringIOs

  let :configuration do
    Rubysmith::CLI::Configuration::Content[
      template_root: Bundler.root.join("spec", "support", "templates"),
      template_path: "%project_name%/lib/%project_path%/identity.rb.erb",
      build_root: temp_dir,
      project_name: "demo-test"
    ]
  end

  let(:build_path) { temp_dir.join "demo-test", "lib", "demo", "test", "identity.rb" }
  let(:output_buffer) { StringIO.new }

  describe ".call" do
    it "answers builder" do
      expect(described_class.call(configuration)).to be_a(described_class)
    end
  end

  describe "#append" do
    before { builder.render }

    it "logs information" do
      builder.append ""
      expect(output_buffer.reread).to match(%r(Appending: demo-test/lib/demo/test/identity.rb\n))
    end

    it "inserts content at end of file" do
      builder.append "# END\n"

      expect(build_path.read).to eq(<<~CONTENT)
        module Identity
          NAME = "demo-test"
        end
        # END
      CONTENT
    end

    it "answers itself" do
      expect(builder.append("")).to be_a(described_class)
    end
  end

  describe "#delete" do
    before { build_path.make_ancestors.touch }

    it "logs information" do
      builder.delete
      expect(output_buffer.reread).to match(%r(Deleting: demo-test/lib/demo/test/identity.rb\n))
    end

    it "deletes existing file" do
      builder.delete
      expect(build_path.exist?).to eq(false)
    end

    it "answers itself" do
      expect(builder.delete).to be_a(described_class)
    end
  end

  describe "#insert_before" do
    before { builder.render }

    it "logs information" do
      builder.insert_before "module Identity", "# Test\n"

      expect(output_buffer.reread).to match(
        %r(Inserting content before pattern in: demo-test/lib/demo/test/identity.rb\n)
      )
    end

    it "inserts content after regular expression" do
      builder.insert_before(/NAME.+/, "  # Test\n")

      expect(build_path.read).to eq(<<~CONTENT)
        module Identity
          # Test
          NAME = "demo-test"
        end
      CONTENT
    end

    it "inserts content after string pattern" do
      builder.insert_before %(NAME = "demo-test"), "  # Test\n"

      expect(build_path.read).to eq(<<~CONTENT)
        module Identity
          # Test
          NAME = "demo-test"
        end
      CONTENT
    end

    it "answers itself" do
      expect(builder.insert_before("module Identity", "# Test\n")).to be_a(described_class)
    end
  end

  describe "#insert_after" do
    before { builder.render }

    it "logs information" do
      builder.insert_after(/NAME.+/, "  # Test\n")

      expect(output_buffer.reread).to match(
        %r(Inserting content after pattern in: demo-test/lib/demo/test/identity.rb\n)
      )
    end

    it "inserts content after regular expression" do
      builder.insert_after(/NAME.+/, "  # Test\n")

      expect(build_path.read).to eq(<<~CONTENT)
        module Identity
          NAME = "demo-test"
          # Test
        end
      CONTENT
    end

    it "inserts content after string pattern" do
      builder.insert_after %(NAME = "demo-test"), "  # Test\n"

      expect(build_path.read).to eq(<<~CONTENT)
        module Identity
          NAME = "demo-test"
          # Test
        end
      CONTENT
    end

    it "answers itself" do
      expect(builder.insert_after(/.+test/, "# Test\n")).to be_a(described_class)
    end
  end

  describe "#permit" do
    before { build_path.make_ancestors.touch }

    it "logs information" do
      builder.permit 0o755

      expect(output_buffer.reread).to match(
        %r(Changing permissions for: demo-test/lib/demo/test/identity.rb\n)
      )
    end

    it "changes file permissions" do
      builder.permit 0o755
      expect(build_path.stat.mode).to eq(33261)
    end

    it "answers itself" do
      expect(builder.permit(0o755)).to be_a(described_class)
    end
  end

  describe "#prepend" do
    before { builder.render }

    it "logs information" do
      builder.prepend "# This is a comment.\n"

      expect(output_buffer.reread).to match(
        %r(Prepending content to: demo-test/lib/demo/test/identity.rb\n)
      )
    end

    it "inserts content at start of file" do
      builder.prepend "# This is a comment.\n"

      expect(build_path.read).to eq(<<~CONTENT)
        # This is a comment.
        module Identity
          NAME = "demo-test"
        end
      CONTENT
    end

    it "answers itself" do
      expect(builder.prepend("Test.\n")).to be_a(described_class)
    end
  end

  describe "#rename" do
    before { build_path.make_ancestors.touch }

    it "logs information" do
      builder.rename "identity.backup"
      expect(output_buffer.reread).to match(/Renaming: identity.rb to identity.backup/)
    end

    it "inserts content at start of file" do
      builder.rename "identity.backup"
      build_path = configuration.build_root.join "demo-test/lib/demo/test/identity.backup"

      expect(build_path.exist?).to eq(true)
    end

    it "answers itself" do
      expect(builder.rename("identity.backup")).to be_a(described_class)
    end
  end

  describe "#render" do
    it "logs information" do
      builder.render
      expect(output_buffer.reread).to match(%r(Rendering: demo-test/lib/demo/test/identity.rb\n))
    end

    it "renders template using nested project name and path" do
      builder.render

      expect(build_path.read).to eq(<<~CONTENT)
        module Identity
          NAME = "demo-test"
        end
      CONTENT
    end

    context "with duplicated project name in path" do
      let :configuration do
        Rubysmith::CLI::Configuration::Content[
          template_root: Bundler.root.join("spec", "support", "templates"),
          template_path: "%project_name%/bin/%project_name%.erb",
          build_root: temp_dir,
          project_name: "demo-test"
        ]
      end

      it "renders template" do
        builder.render

        expect(temp_dir.join("demo-test/bin/demo-test").read).to eq(<<~CONTENT)
          #! /usr/bin/env ruby

          require "demo-test"

          puts "Test."
        CONTENT
      end
    end

    it "answers itself" do
      expect(builder.render).to be_a(described_class)
    end
  end

  describe "#replace" do
    before { builder.render }

    it "logs information" do
      builder.replace(/NAME.+/, %(LABEL = "Replaced"))
      expect(output_buffer.reread).to match(
        %r(Replacing content for patterns in: demo-test/lib/demo/test/identity.rb\n)
      )
    end

    it "replaces existing content with new content" do
      builder.replace(/NAME.+/, %(LABEL = "Replaced"))

      expect(build_path.read).to eq(<<~CONTENT)
        module Identity
          LABEL = "Replaced"
        end
      CONTENT
    end

    it "answers itself" do
      expect(builder.replace("demo-test", "replaced")).to be_a(described_class)
    end
  end

  describe "#run" do
    context "when success" do
      it "logs information" do
        builder.run %(echo "Test.")
        expect(output_buffer.reread).to match(/Test./)
      end

      it "answers self" do
        expect(builder.run(%(echo "Test."))).to be_a(described_class)
      end
    end

    context "when minor failure" do
      it "logs information" do
        builder.run "hostname -x"
        expect(output_buffer.reread).to match(/.+(illegal|unrecognized) option.+/m)
      end

      it "answers self" do
        expect(builder.run("hostname -x")).to be_a(described_class)
      end
    end

    context "when major failure" do
      it "logs information" do
        builder.run "bogus"
        expect(output_buffer.reread).to match(/No such file or director/)
      end

      it "answers self" do
        expect(builder.run("bogus")).to be_a(described_class)
      end
    end
  end

  describe "#touch" do
    it "logs information" do
      builder.touch
      expect(output_buffer.reread).to match(%r(Touching: demo-test/lib/demo/test/identity.rb\n))
    end

    it "creates empty file" do
      builder.touch
      expect(build_path.exist?).to eq(true)
    end

    it "creates empty directory" do
      described_class.new(configuration.with(template_path: "test/path")).touch
      expect(temp_dir.join("test", "path").exist?).to eq(true)
    end

    it "answers itself" do
      expect(builder.touch).to be_a(described_class)
    end
  end
end
