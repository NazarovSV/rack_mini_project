# frozen_string_literal: true

class DateFormatter
  AUTHORIZED_FORMAT = { year: '%Y', month: '%m', day: '%d', hour: '%H', minute: '%M', second: '%S' }.freeze
  DELIMITER = ','

  def date(formats)
    result = invalid_formats(formats)

    if result.any?
      { error: "Unknown time format [#{result.join(', ')}]" }
    else
      { value: formatted_date(formats) }
    end
  end

  private

  def formatted_date(formats)
    time_format = formats.split(DELIMITER).map { |format| AUTHORIZED_FORMAT[format.downcase.to_sym] }.join('/')
    Time.now.strftime(time_format)
  end

  def invalid_formats(formats)
    formats.split(DELIMITER).select { |format| !AUTHORIZED_FORMAT.key?(format.downcase.to_sym) }
  end
end
