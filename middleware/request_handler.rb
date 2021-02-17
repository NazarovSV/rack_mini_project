# frozen_string_literal: true

require_relative '../services/date_formatting_service'
require_relative '../utils/format_validator'

class RequestHandler
  def initialize(app, **options)
    @app = app
    @delimiter = options[:delimiter] || ','
  end

  def call(env)
    request = Rack::Request.new(env)

    unless valid_request?(request)
      return Rack::Response.new(['Not Found'], Rack::Utils.status_code(:not_found),
                                {}).finish
    end

    if format_parameter_not_exist?(request)
      return Rack::Response.new(["No format parameters. Query string: \"#{request.query_string}\""],
                                Rack::Utils.status_code(:bad_request), {}).finish
    end

    result = FormatValidator.new(request.params['format'], @delimiter).validate

    if result.has_error?
      Rack::Response.new(["Unknown time format [#{result.errors.join(', ')}]"],
                         Rack::Utils.status_code(:bad_request), {}).finish
    else
      env[:date_format] = result.valid_formats
      @app.call(env)
    end
  end

  private

  def format_parameter_not_exist?(request)
    !request.params.key?('format') || request.params['format'].nil? || request.params['format'].empty?
  end

  def valid_request?(request)
    request.path == '/time' && request.request_method == 'GET'
  end
end
