# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Pathway do
  using Refinements::Pathnames

  subject :way do
    described_class.new start_root: "/source",
                        start_path: "/source/views/test.html.erb",
                        end_root: "/build"
  end

  shared_examples "a frozen member" do |method|
    it "fails when attempting to be set" do
      expectation = proc { way.public_send "#{method}=", "invalid" }
      expect(&expectation).to raise_error(FrozenError, /can't modify/)
    end
  end

  describe "#initialize" do
    it "answers default attributes" do
      expect(described_class.new).to have_attributes(
        start_root: Pathname(""),
        start_path: Pathname("."),
        end_root: Pathname("")
      )
    end

    it "answers custom attributes" do
      expect(way).to have_attributes(
        start_root: Pathname("/source"),
        start_path: Pathname("/source/views/test.html.erb"),
        end_root: Pathname("/build")
      )
    end

    it "accepts strings and paths" do
      way = described_class.new start_root: "/a",
                                start_path: Pathname("/a/test.txt"),
                                end_root: "/b"

      expect(way).to have_attributes(
        start_root: Pathname("/a"),
        start_path: Pathname("/a/test.txt"),
        end_root: Pathname("/b")
      )
    end

    it "answers absolute path when start path is absolute" do
      expect(way.start_path).to eq(Pathname("/source/views/test.html.erb"))
    end

    it "answers absolute path when start path is relative" do
      way = described_class.new start_root: "/source",
                                start_path: "test.html.erb",
                                end_root: "/build"
      expect(way.start_path).to eq(Pathname("/source/test.html.erb"))
    end
  end

  describe "#start_root" do
    it_behaves_like "a frozen member", :start_root
  end

  describe "#start_path" do
    it_behaves_like "a frozen member", :start_path
  end

  describe "#end_root" do
    it_behaves_like "a frozen member", :end_root
  end

  describe "#with" do
    it "answers combination of old and new struct with single attribute" do
      proof = described_class[
        start_root: "/source",
        start_path: "/source/test.txt",
        end_root: "/build"
      ]

      expect(way.with(start_path: Pathname("/source/test.txt"))).to eq(proof)
    end

    it "answers combination of old and new struct with multiple attributes" do
      expectation = way.with start_root: Pathname("/in"), start_path: Pathname("/in/test.txt")

      proof = described_class[
        start_root: Pathname("/in"),
        start_path: Pathname("/in/test.txt"),
        end_root: Pathname("/build")
      ]

      expect(expectation).to eq(proof)
    end
  end

  describe "#end_path" do
    it "answers full path when start path is relative" do
      end_path = way.with(start_path: "views/attachments/test.txt").end_path
      expect(end_path).to eq(Pathname("/build/views/attachments/test.txt"))
    end

    it "answers full path when start path has no extension" do
      end_path = way.with(start_path: "/source/views/test").end_path
      expect(end_path).to eq(Pathname("/build/views/test"))
    end

    it "answers full path when start path single extension" do
      end_path = way.with(start_path: "/source/views/test.html").end_path
      expect(end_path).to eq(Pathname("/build/views/test.html"))
    end
  end

  describe "#partial?" do
    it "answers true with partial source file" do
      expect(way.with(start_path: "/source/views/_test.html.erb").partial?).to be(true)
    end

    it "answers false with template source file" do
      expect(way.with(start_path: "/source/views/test.html.erb").partial?).to be(false)
    end
  end
end
