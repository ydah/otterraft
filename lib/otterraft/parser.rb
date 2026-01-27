# frozen_string_literal: true

require "yaml"
require "ostruct"
require_relative "errors"
require_relative "options"
require_relative "result"

module Otterraft
  class Parser
    FRONTMATTER_REGEX = /\A---[ \t]*\n(?<content>.*?)(?:\n---|\n\.\.\.)[ \t]*(?:\n|\z)/m.freeze
    MULTI_DOCUMENT_REGEX = /(?:\A|(?<=\n))---[ \t]*\n(?<content>.*?)(?:\n---|\n\.\.\.)[ \t]*(?=\n|\z)/m.freeze

    def initialize(text, options = Options.new)
      @text = text
      @options = options
    end

    def parse
      @options.multiple ? parse_multiple : parse_single
    end

    def parse_with_body
      match = @text.match(FRONTMATTER_REGEX)
      return handle_no_frontmatter_with_body if match.nil?

      frontmatter = load_and_transform(match[:content])
      body = @text[match.end(0)..]&.lstrip || ""

      Result.new(frontmatter: frontmatter, body: body, raw: @text)
    end

    private

    def parse_single
      match = @text.match(FRONTMATTER_REGEX)
      return handle_no_frontmatter if match.nil?

      load_and_transform(match[:content])
    end

    def parse_multiple
      matches = @text.scan(MULTI_DOCUMENT_REGEX)
      return handle_no_frontmatter_multiple if matches.empty?

      matches.map do |content|
        yaml_content = content.is_a?(Array) ? content.first : content
        load_and_transform(yaml_content)
      end
    end

    def load_and_transform(content)
      hash = YAML.safe_load(content) || {}
      transform_result(hash)
    rescue Psych::SyntaxError => e
      raise ParseError, "Invalid YAML syntax: #{e.message}"
    end

    def transform_result(hash)
      transformed = @options.symbolize_keys ? symbolize_keys_deep(hash) : hash
      return transformed unless @options.format == :open_struct

      to_open_struct(transformed)
    end

    def symbolize_keys_deep(obj)
      case obj
      when Hash
        obj.transform_keys(&:to_sym).transform_values { |v| symbolize_keys_deep(v) }
      when Array
        obj.map { |v| symbolize_keys_deep(v) }
      else
        obj
      end
    end

    def to_open_struct(hash)
      OpenStruct.new(
        hash.transform_values { |v| v.is_a?(Hash) ? to_open_struct(v) : v }
      )
    end

    def handle_no_frontmatter
      raise ParseError, "No front matter found" if @options.strict

      nil
    end

    def handle_no_frontmatter_multiple
      raise ParseError, "No front matter found" if @options.strict

      []
    end

    def handle_no_frontmatter_with_body
      raise ParseError, "No front matter found" if @options.strict

      Result.new(frontmatter: nil, body: @text, raw: @text)
    end
  end
end
