# frozen_string_literal: true

require_relative '../services/date_formatter'

class RequestHandler
  include Rack::Utils

  def initialize(app, **options)
    @app = app
    @delimiter = options[:delimiter] || ','
  end

  def call(env)
    request = Rack::Request.new(env)

    if valid_request?(request)
      @app.call(env)
    else
      Rack::Response.new(['Not Found'], status_code(:not_found),
                         {}).finish
    end
  end

  private

  def valid_request?(request)
    request.path == '/time' && request.request_method == 'GET'
  end
end
