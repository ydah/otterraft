# frozen_string_literal: true

RSpec.describe Otterraft do
  describe ".parse" do
    subject(:parse) { described_class.parse(text) }

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

    context "when the text not contains front matter" do
      let(:text) { "Hello, World!" }

      it "raises an error if no front matter is found" do
        expect { parse }.to raise_error(Otterraft::ParseError, "No front matter found")
      end
    end
  end

  describe ".parse_file" do
    subject(:parse_file) { described_class.parse_file(pathname) }

    context "when the file exists" do
      let(:pathname) { "spec/fixtures/hello.md" }

      it "parses the file" do
        expect(parse_file).to eq(
          "date" => "2021-01-01 12:00 JST",
          "tags" => %w[hello world ruby],
          "title" => "Hello, World!"
        )
      end
    end

    context "when the file does not exist" do
      let(:pathname) { "spec/fixtures/unknown.md" }

      it "raises an error if the file does not exist" do
        expect { parse_file }.to raise_error(Otterraft::FileNotFoundError, "File not found: #{pathname}")
      end
    end
  end

  describe ".parse_with_body" do
    subject(:parse_with_body) { described_class.parse_with_body(text) }

    let(:text) { "---\ntitle: Hello\n---\n\nBody content here." }

    it "returns a structured result" do
      result = parse_with_body
      expect(result).to be_a(Otterraft::Result)
      expect(result.frontmatter).to eq({ "title" => "Hello" })
      expect(result.body).to eq("Body content here.")
    end
  end
end
