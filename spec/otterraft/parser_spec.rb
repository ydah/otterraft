# frozen_string_literal: true

require "otterraft/parser"

RSpec.describe Otterraft::Parser do
  let(:instance) { described_class.new(text) }

  describe "#parse" do
    subject { instance.parse }

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
        expect(subject).to eq(
          "date" => "2021-01-01 12:00 JST",
          "tags" => ["hello", "world", "ruby"],
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
        expect(subject).to eq(
          "date" => "2021-01-01 12:00 JST",
          "tags" => ["hello", "world", "ruby"],
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
        expect { subject }.to raise_error("No front matter found")
      end
    end

    context "when the text not contains front matter" do
      let(:text) { "Hello, World!" }

      it "raises an error if no front matter is found" do
        expect { subject }.to raise_error("No front matter found")
      end
    end
  end
end
