# frozen_string_literal: true

require_relative "otterraft/parser"
require_relative "otterraft/version"

module Otterraft
  def self.parse(text)
    Parser.new(text).parse
  end

  def self.parse_file(pathname)
    raise "File not found: #{pathname}" unless File.exist?(pathname)
    Parser.new(File.read(pathname)).parse
  end
end
