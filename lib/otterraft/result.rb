# frozen_string_literal: true

module Otterraft
  class Result
    attr_reader :frontmatter, :body, :raw

    def initialize(frontmatter:, body:, raw:)
      @frontmatter = frontmatter
      @body = body
      @raw = raw
    end

    def to_h
      { frontmatter: frontmatter, body: body, raw: raw }
    end
  end
end
