# frozen_string_literal: true

require "spec_helper"
require "refinements/pathnames"
require "refinements/string_ios"

RSpec.describe Rubysmith::Builder, :temp_dir do
  using Refinements::Pathnames
  using Refinements::StringIOs

  subject :builder do
    described_class.new realm.with(template_path: "%project_name%/bin/test.erb"),
                        helpers: {
                          inserter: Rubysmith::Text::Inserter,
                          renderer: Rubysmith::Renderers::ERB,
                          kernel: Open3,
                          logger: Logger.new(output_buffer)
                        }
  end

  let :realm do
    Rubysmith::Realm[
      template_root: Bundler.root.join("spec", "support", "templates"),
      build_root: temp_dir,
      project_name: "test"
    ]
  end

  let(:build_path) { temp_dir.join "test", "bin", "test" }
  let(:output_buffer) { StringIO.new }

  describe ".call" do
    it "answers builder" do
      expect(described_class.call(realm)).to be_a(described_class)
    end
  end

  describe "#append" do
    before { builder.render }

    it "logs information" do
      builder.append ""
      expect(output_buffer.reread).to match(%r(Appending: test/bin/test\n))
    end

    it "inserts content at end of file" do
      proof = <<~CONTENT
        #! /usr/bin/env ruby

        require "test"

        puts "Test."
        puts "END"
      CONTENT

      builder.append %(puts "END"\n)
      expect(build_path.read).to eq(proof)
    end

    it "answers itself" do
      expect(builder.append("")).to be_a(described_class)
    end
  end

  describe "#delete" do
    before { build_path.make_ancestors.touch }

    it "logs information" do
      builder.delete
      expect(output_buffer.reread).to match(%r(Deleting: test/bin/test\n))
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
      builder.insert_before(/require.+test/, "# Test\n")

      expect(output_buffer.reread).to match(
        %r(Inserting content before pattern in: test/bin/test\n)
      )
    end

    it "inserts content after regular expression" do
      proof = <<~CONTENT
        #! /usr/bin/env ruby

        require "pathname"
        require "test"

        puts "Test."
      CONTENT

      builder.insert_before(/require.+test/, %(require "pathname"\n))
      expect(build_path.read).to eq(proof)
    end

    it "inserts content after string pattern" do
      proof = <<~CONTENT
        #! /usr/bin/env ruby

        require "pathname"
        require "test"

        puts "Test."
      CONTENT

      builder.insert_before %(require "test"\n), %(require "pathname"\n)
      expect(build_path.read).to eq(proof)
    end

    it "answers itself" do
      expect(builder.insert_before(/.+test/, "# Test\n")).to be_a(described_class)
    end
  end

  describe "#insert_after" do
    before { builder.render }

    it "logs information" do
      builder.insert_after(/require.+test/, "# Test\n")
      expect(output_buffer.reread).to match(%r(Inserting content after pattern in: test/bin/test\n))
    end

    it "inserts content after regular expression" do
      proof = <<~CONTENT
        #! /usr/bin/env ruby

        require "test"
        require "pathname"

        puts "Test."
      CONTENT

      builder.insert_after(/require.+test/, %(require "pathname"\n))
      expect(build_path.read).to eq(proof)
    end

    it "inserts content after string pattern" do
      proof = <<~CONTENT
        #! /usr/bin/env ruby

        require "test"
        require "pathname"

        puts "Test."
      CONTENT

      builder.insert_after %(require "test"\n), %(require "pathname"\n)
      expect(build_path.read).to eq(proof)
    end

    it "answers itself" do
      expect(builder.insert_after(/.+test/, "# Test\n")).to be_a(described_class)
    end
  end

  describe "#permit" do
    before { build_path.make_ancestors.touch }

    it "logs information" do
      builder.permit 0o755
      expect(output_buffer.reread).to match(%r(Changing permissions for: test/bin/test\n))
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
      expect(output_buffer.reread).to match(%r(Prepending content to: test/bin/test\n))
    end

    it "inserts content at start of file" do
      proof = <<~CONTENT
        # This is a comment.
        #! /usr/bin/env ruby

        require "test"

        puts "Test."
      CONTENT

      builder.prepend "# This is a comment.\n"
      expect(build_path.read).to eq(proof)
    end

    it "answers itself" do
      expect(builder.prepend("Test.\n")).to be_a(described_class)
    end
  end

  describe "#rename" do
    before { build_path.make_ancestors.touch }

    it "logs information" do
      builder.rename "test.backup"
      expect(output_buffer.reread).to match(/Renaming: test to test.backup/)
    end

    it "inserts content at start of file" do
      builder.rename "test.backup"
      expect(realm.build_root.join("test", "bin", "test.backup").exist?).to eq(true)
    end

    it "answers itself" do
      expect(builder.rename("test.backup")).to be_a(described_class)
    end
  end

  describe "#render" do
    let :content do
      <<~CONTENT
        #! /usr/bin/env ruby

        require "test"

        puts "Test."
      CONTENT
    end

    it "logs information" do
      builder.render
      expect(output_buffer.reread).to match(%r(Rendering: test/bin/test\n))
    end

    it "renders template" do
      builder.render
      expect(build_path.read).to eq(content)
    end

    it "answers itself" do
      expect(builder.render).to be_a(described_class)
    end
  end

  describe "#replace" do
    before { builder.render }

    it "logs information" do
      builder.replace(/^(puts|require).+/, "# Replaced.")
      expect(output_buffer.reread).to match(%r(Replacing content for patterns in: test/bin/test\n))
    end

    it "inserts content at end of file" do
      proof = <<~CONTENT
        #! /usr/bin/env ruby

        # Replaced.

        # Replaced.
      CONTENT

      builder.replace(/^(puts|require).+/, "# Replaced.")
      expect(build_path.read).to eq(proof)
    end

    it "answers itself" do
      expect(builder.replace(/^puts.+/, "# Replaced.")).to be_a(described_class)
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
        expect(output_buffer.reread).to match(/.+(illegal|invalid) option.+/m)
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
      expect(output_buffer.reread).to match(%r(Touching: test/bin/test\n))
    end

    it "creates empty file" do
      builder.touch
      expect(build_path.exist?).to eq(true)
    end

    it "creates empty directory" do
      described_class.new(realm.with(template_path: "test/path")).touch
      expect(temp_dir.join("test", "path").exist?).to eq(true)
    end

    it "answers itself" do
      expect(builder.touch).to be_a(described_class)
    end
  end
end
