# frozen_string_literal: true

require_relative 'services/date_formatting_service'
class App
  def initialize(delimiter)
    @delimiter = delimiter
  end

  def call(env)
    request = Rack::Request.new(env)

    if format_parameter_exist?(request)
      date_format_responce(request)
    else
      Rack::Response.new(["No format parameters. Query string: \"#{request.query_string}\""],
                         Rack::Utils.status_code(:bad_request), {}).finish
    end
  end

  private

  def format_parameter_exist?(request)
    request.params.key?('format') && !request.params['format'].nil? && !request.params['format'].empty?
  end

  def date_format_responce(request)
    result = DateFormattingService.new.date(request.params['format'], @delimiter)

    if result.success?
      Rack::Response.new([result.value], Rack::Utils.status_code(:ok), {}).finish
    else
      Rack::Response.new([result.error], Rack::Utils.status_code(:bad_request), {}).finish
    end
  end
end
