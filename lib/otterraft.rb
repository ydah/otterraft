# frozen_string_literal: true

require_relative "otterraft/errors"
require_relative "otterraft/options"
require_relative "otterraft/result"
require_relative "otterraft/parser"
require_relative "otterraft/version"

module Otterraft
  class << self
    def parse(text, **options)
      Parser.new(text, build_options(options)).parse
    end

    def parse_file(pathname, **options)
      raise FileNotFoundError, "File not found: #{pathname}" unless File.exist?(pathname)

      parse(File.read(pathname), **options)
    end

    def parse_with_body(text, **options)
      Parser.new(text, build_options(options)).parse_with_body
    end

    def parse_file_with_body(pathname, **options)
      raise FileNotFoundError, "File not found: #{pathname}" unless File.exist?(pathname)

      parse_with_body(File.read(pathname), **options)
    end

    private

    def build_options(options)
      Options.new(**options)
    end
  end
end
