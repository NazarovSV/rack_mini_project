# frozen_string_literal: true

require_relative 'format_validator_response'
class FormatValidator
  def initialize(formats, delimiter)
    @formats = formats
    @delimiter = delimiter
  end

  def validate
    responce = FormatValidatorResponce.new
    @formats.split(@delimiter).each do |format|
      if DateFormattingService::AUTHORIZED_FORMAT.key?(format.downcase.to_sym)
        responce.add_valid_format(format.downcase.to_sym)
      else
        responce.add_error(format)
      end
    end
    responce
  end
end
