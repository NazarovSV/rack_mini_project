require_relative 'services/date_formatting_service'
class App
  def call(env)
    [status, header, body(env)]
  end

  private

  def status
    200
  end

  def header
    { 'Content-Type' => 'text/plain' }
  end

  def body(env)
    [] << DateFormattingService.new.get_date(env[:date_format])
  end
end
