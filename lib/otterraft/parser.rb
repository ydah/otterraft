# frozen_string_literal: true

require "yaml"

module Otterraft
  class Parser
    FRONTMATTER_REGEX = /^---\n(?<content>.+?)(?:\n---|\n\.\.\.)$/m.freeze

    def initialize(text)
      @text = text
    end

    def parse
      front_matter = @text.match(FRONTMATTER_REGEX) || raise("No front matter found")
      YAML.safe_load(front_matter[:content])
    end
  end
end
