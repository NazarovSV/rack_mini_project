# frozen_string_literal: true

require_relative '../services/date_formatting_service'

class RequestHandler
  def initialize(app, **options)
    @app = app
    @delimiter = options[:delimiter] || ','
  end

  def call(env)
    request = Rack::Request.new(env)

    if valid_request?(request)
      @app.call(env)
    else
      Rack::Response.new(['Not Found'], Rack::Utils.status_code(:not_found),
                         {}).finish
    end
  end

  private

  def valid_request?(request)
    request.path == '/time' && request.request_method == 'GET'
  end
end
