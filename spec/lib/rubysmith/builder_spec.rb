# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builder do
  subject(:builder) { described_class.new configuration }

  include_context "with application container"

  using Refinements::Pathnames
  using Refinements::StringIOs
  using Refinements::Structs

  let :configuration do
    Rubysmith::Configuration::Content[
      template_roots: [Bundler.root.join("spec/support/fixtures/templates")],
      template_path: "%project_name%/lib/%project_path%/identity.rb.erb",
      target_root: temp_dir,
      project_name: "demo-test"
    ]
  end

  let(:build_path) { temp_dir.join "demo-test", "lib", "demo", "test", "identity.rb" }

  describe ".call" do
    it "answers builder" do
      expect(described_class.call(configuration)).to be_a(described_class)
    end
  end

  describe "#append" do
    before { builder.render }

    it "logs information" do
      build = proc { builder.append "" }
      expect(&build).to output(%r(Appending: demo-test/lib/demo/test/identity.rb\n)).to_stdout
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
    before { build_path.deep_touch }

    it "logs information" do
      build = proc { builder.delete }
      expect(&build).to output(%r(Deleting: demo-test/lib/demo/test/identity.rb\n)).to_stdout
    end

    it "deletes existing file" do
      builder.delete
      expect(build_path.exist?).to be(false)
    end

    it "answers itself" do
      expect(builder.delete).to be_a(described_class)
    end
  end

  describe "#insert_before" do
    before { builder.render }

    it "logs information" do
      build = proc { builder.insert_before "module Identity", "# Test\n" }

      expect(&build).to output(
        %r(Inserting content before pattern in: demo-test/lib/demo/test/identity.rb\n)
      ).to_stdout
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
      build = proc { builder.insert_after(/NAME.+/, "  # Test\n") }

      expect(&build).to output(
        %r(Inserting content after pattern in: demo-test/lib/demo/test/identity.rb\n)
      ).to_stdout
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
    before { build_path.deep_touch }

    it "logs information" do
      build = proc { builder.permit 0o755 }

      expect(&build).to output(
        %r(Changing permissions for: demo-test/lib/demo/test/identity.rb\n)
      ).to_stdout
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
      build = proc { builder.prepend "# This is a comment.\n" }

      expect(&build).to output(
        %r(Prepending content to: demo-test/lib/demo/test/identity.rb\n)
      ).to_stdout
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
    before { build_path.deep_touch }

    it "logs information" do
      build = proc { builder.rename "identity.backup" }
      expect(&build).to output(/Renaming: identity.rb to identity.backup/).to_stdout
    end

    it "inserts content at start of file" do
      builder.rename "identity.backup"
      build_path = configuration.target_root.join "demo-test/lib/demo/test/identity.backup"

      expect(build_path.exist?).to be(true)
    end

    it "answers itself" do
      expect(builder.rename("identity.backup")).to be_a(described_class)
    end
  end

  describe "#render" do
    it "logs information" do
      build = proc { builder.render }
      expect(&build).to output(%r(Rendering: demo-test/lib/demo/test/identity.rb\n)).to_stdout
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
        Rubysmith::Configuration::Content[
          template_roots: [Bundler.root.join("spec/support/fixtures/templates")],
          template_path: "%project_name%/bin/%project_name%.erb",
          target_root: temp_dir,
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
      build = proc { builder.replace(/NAME.+/, %(LABEL = "Replaced")) }

      expect(&build).to output(
        %r(Replacing content for patterns in: demo-test/lib/demo/test/identity.rb\n)
      ).to_stdout
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
        build = proc { builder.run %(echo "Test.") }
        expect(&build).to output(/Test./).to_stdout
      end

      it "answers self" do
        expect(builder.run(%(echo "Test."))).to be_a(described_class)
      end
    end

    context "when minor failure" do
      it "logs information" do
        build = proc { builder.run "hostname -x" }
        expect(&build).to output(/.+(illegal|unrecognized) option.+/m).to_stdout
      end

      it "answers self" do
        expect(builder.run("hostname -x")).to be_a(described_class)
      end
    end

    context "when major failure" do
      it "logs information" do
        build = proc { builder.run "bogus" }
        expect(&build).to output(/No such file or director/).to_stdout
      end

      it "answers self" do
        expect(builder.run("bogus")).to be_a(described_class)
      end
    end
  end

  describe "#touch" do
    it "logs information" do
      build = proc { builder.touch }
      expect(&build).to output(%r(Touching: demo-test/lib/demo/test/identity.rb\n)).to_stdout
    end

    it "creates empty file" do
      builder.touch
      expect(build_path.exist?).to be(true)
    end

    it "creates empty directory" do
      described_class.new(configuration.merge(template_path: "test/path")).touch
      expect(temp_dir.join("test", "path").exist?).to be(true)
    end

    it "answers itself" do
      expect(builder.touch).to be_a(described_class)
    end
  end
end
