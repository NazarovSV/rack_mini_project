class DateFormattingService
  AUTHORIZED_FORMAT = { year: '%Y', month: '%m', day: '%d', hour: '%H', minute: '%M', second: '%S' }

  def get_date(formats)
    time_format = formats.map { |format| AUTHORIZED_FORMAT[format] }.join('/')
    Time.now.strftime(time_format)
  end
end
