# frozen_string_literal: true

module Otterraft
  class Error < StandardError; end
  class ParseError < Error; end
  class FileNotFoundError < Error; end
end
