# frozen_string_literal: true

require_relative 'date_formatting_response'

class DateFormattingService
  AUTHORIZED_FORMAT = { year: '%Y', month: '%m', day: '%d', hour: '%H', minute: '%M', second: '%S' }.freeze

  def date(formats, delimiter)
    response = DateFormatterResponse.new
    result = invalid_formats(formats, delimiter)

    if result.any?
      response.error = "Unknown time format [#{result.join(', ')}]"
    else
      response.value = formatted_date(formats, delimiter)
    end

    response
  end

  private

  def formatted_date(formats, delimiter)
    time_format = formats.split(delimiter).map { |format| AUTHORIZED_FORMAT[format.downcase.to_sym] }.join('/')
    Time.now.strftime(time_format)
  end

  def invalid_formats(formats, delimiter)
    invalid_formats = []
    formats.split(delimiter).each do |format|
      invalid_formats << format unless AUTHORIZED_FORMAT.key?(format.downcase.to_sym)
    end
    invalid_formats
  end
end
