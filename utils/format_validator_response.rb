# frozen_string_literal: true

class FormatValidatorResponce
  attr_reader :valid_formats, :errors

  def initialize
    @valid_formats = []
    @errors = []
  end

  def add_valid_format(format)
    @valid_formats << format
  end

  def add_error(error)
    @errors << error
  end

  def has_error?
    @errors.any?
  end
end
