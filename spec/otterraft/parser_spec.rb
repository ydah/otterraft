# frozen_string_literal: true

require "otterraft/parser"

RSpec.describe Otterraft::Parser do
  let(:options) { Otterraft::Options.new }
  let(:instance) { described_class.new(text, options) }

  describe "#parse" do
    subject(:parse) { instance.parse }

    context "when the text contains front matter" do
      let(:text) do
        <<~TEXT
          ---
          title: "Hello, World!"
          date: 2021-01-01 12:00 JST
          tags:
          - hello
          - world
          - ruby
          ---

          ## Hello, World!
          - Hello
          - World
        TEXT
      end

      it "parses front matter" do
        expect(parse).to eq(
          "date" => "2021-01-01 12:00 JST",
          "tags" => %w[hello world ruby],
          "title" => "Hello, World!"
        )
      end
    end

    context "when the text contains front matter and ends with '...'" do
      let(:text) do
        <<~TEXT
          ---
          title: "Hello, World!"
          date: 2021-01-01 12:00 JST
          tags:
          - hello
          - world
          - ruby
          ...
        TEXT
      end

      it "parses front matter" do
        expect(parse).to eq(
          "date" => "2021-01-01 12:00 JST",
          "tags" => %w[hello world ruby],
          "title" => "Hello, World!"
        )
      end
    end

    context "when the text contains invalid front matter" do
      let(:text) do
        <<~TEXT
          ---
          title: "Hello, World!"
          date: 2021-01-01 12:00 JST
          tags:
          - hello
          - world
          - ruby
        TEXT
      end

      it "raises an error if the front matter is invalid" do
        expect { parse }.to raise_error(Otterraft::ParseError, "No front matter found")
      end
    end

    context "when the text not contains front matter" do
      let(:text) { "Hello, World!" }

      it "raises an error if no front matter is found" do
        expect { parse }.to raise_error(Otterraft::ParseError, "No front matter found")
      end
    end
  end

  describe "#parse with options" do
    context "with symbolize_keys: true" do
      let(:options) { Otterraft::Options.new(symbolize_keys: true) }
      let(:text) { "---\ntitle: Hello\n---\n" }

      it "returns symbolized keys" do
        expect(instance.parse).to eq({ title: "Hello" })
      end
    end

    context "with format: :open_struct" do
      let(:options) { Otterraft::Options.new(format: :open_struct) }
      let(:text) { "---\ntitle: Hello\n---\n" }

      it "returns OpenStruct" do
        result = instance.parse
        expect(result).to be_a(OpenStruct)
        expect(result.title).to eq("Hello")
      end
    end

    context "with multiple: true" do
      let(:options) { Otterraft::Options.new(multiple: true) }
      let(:text) { "---\ntitle: Doc1\n---\n---\ntitle: Doc2\n---\n" }

      it "returns array of hashes" do
        expect(instance.parse).to eq([
          { "title" => "Doc1" },
          { "title" => "Doc2" }
        ])
      end
    end

    context "with strict: false and no frontmatter" do
      let(:options) { Otterraft::Options.new(strict: false) }
      let(:text) { "No frontmatter here" }

      it "returns nil" do
        expect(instance.parse).to be_nil
      end
    end
  end

  describe "#parse_with_body" do
    let(:text) { "---\ntitle: Hello\n---\n\nBody content here." }

    it "returns Result with frontmatter and body" do
      result = instance.parse_with_body
      expect(result).to be_a(Otterraft::Result)
      expect(result.frontmatter).to eq({ "title" => "Hello" })
      expect(result.body).to eq("Body content here.")
    end
  end

  describe "markdown horizontal rule distinction" do
    let(:text) do
      <<~TEXT
        ---
        title: Hello
        ---

        Some content

        ---

        More content after horizontal rule
      TEXT
    end

    it "does not confuse horizontal rules with frontmatter" do
      result = instance.parse_with_body
      expect(result.frontmatter).to eq({ "title" => "Hello" })
      expect(result.body).to include("---")
      expect(result.body).to include("More content after horizontal rule")
    end
  end
end
