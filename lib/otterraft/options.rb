# frozen_string_literal: true

module Otterraft
  class Options
    VALID_FORMATS = %i[hash open_struct].freeze

    attr_reader :symbolize_keys, :format, :multiple, :strict

    def initialize(symbolize_keys: false, format: :hash, multiple: false, strict: true)
      @symbolize_keys = symbolize_keys
      @format = validate_format(format)
      @multiple = multiple
      @strict = strict
    end

    private

    def validate_format(format)
      return format if VALID_FORMATS.include?(format)

      raise ArgumentError, "Invalid format: #{format}. Valid formats: #{VALID_FORMATS.join(', ')}"
    end
  end
end
