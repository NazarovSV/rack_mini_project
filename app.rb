# frozen_string_literal: true

require_relative 'services/date_formatting_service'
class App
  def call(env)
    Rack::Response.new(body(env), Rack::Utils.status_code(:ok), {}).finish
  end

  private

  def body(env)
    [] << DateFormattingService.new.get_date(env[:date_format])
  end
end
