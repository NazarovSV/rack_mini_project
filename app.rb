require_relative 'service/date_formatting_service'
class App
  def call(env)
    body = [] << DateFormattingService.new.get_date(env[:date_format])
    [status, header, body]
  end

  private

  def status
    200
  end

  def header
    { 'Content-Type' => 'text/plain' }
  end
end