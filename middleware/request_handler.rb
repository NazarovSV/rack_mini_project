require_relative '../service/date_formatting_service'

class RequestHandler
  def initialize(app, **options)
    @app = app
    @delimiter = options[:delimiter] || ','
  end

  def call(env)
    return [not_found_code, header, not_found_body] unless valid_request?(env['REQUEST_PATH'], env['REQUEST_METHOD'])

    params = validate_query_params(env['QUERY_STRING'])

    if params[:errors].any?
      [bad_request_code, header, params[:errors]]
    else
      env[:date_format] = params[:formats]
      @app.call(env)
    end
  end

  private

  def valid_request?(raw_path, raw_method)
    path = parse(raw_path)
    method = parse(raw_method)
    path.keys.first == '/time' && method.keys.first == 'GET'
  end

  def validate_query_params(raw_query)
    output = { formats: [], errors: [] }
    query = parse(raw_query)

    if query['format'].nil? || !query.key?('format')
      output[:errors] << "No format parameter #{raw_query}"
      return output
    end

    formats = validate_formats(query)

    output[:formats] = formats[:valid]
    output[:errors] = ["Unknown time format [#{formats[:invalid].join(', ')}]"] if formats[:invalid].any?
    output
  end

  def validate_formats(query)
    formats = { valid: [], invalid: [] }
    query['format'].split(@delimiter).each do |format|
      if DateFormattingService::AUTHORIZED_FORMAT.key?(format.downcase.to_sym)
        formats[:valid] << format.downcase.to_sym
      else
        formats[:invalid] << format
      end
    end
    formats
  end

  def not_found_code
    404
  end

  def bad_request_code
    400
  end

  def header
    { 'Content-Type' => 'text/plain' }
  end

  def not_found_body
    ['Not Found!']
  end

  def parse(text)
    Rack::Utils.parse_nested_query(text)
  end
end
