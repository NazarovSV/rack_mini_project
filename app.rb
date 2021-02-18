# frozen_string_literal: true

require_relative 'services/date_formatter'

class App
  include Rack::Utils

  def call(env)
    request = Rack::Request.new(env)
    response = Rack::Response.new

    if format_parameter_exist?(request)
      response.body, response.status = date_format_response(request)
    else
      response.body = ["No format parameters. Query string: \"#{request.query_string}\""]
      response.status = status_code(:bad_request)
    end
    response.finish
  end

  private

  def format_parameter_exist?(request)
    request.params.key?('format') && !request.params['format'].nil? && !request.params['format'].empty?
  end

  def date_format_response(request)
    result = DateFormatter.new.date(request.params['format'])

    if result.key? :error
      return [result[:error]], status_code(:ok)
    else
      return [result[:value]], status_code(:bad_request)
    end
  end
end
