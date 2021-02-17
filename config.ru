# frozen_string_literal: true

require_relative 'app'
require_relative 'middleware/logger'
require_relative 'middleware/request_handler'

use AppLogger, logdev: File.expand_path('log/app.log', __dir__)
use RequestHandler, delimiter: ','
use Rack::ContentType, 'text/plain'

ROUTES = {
  '/time' => RequestHandler.new(App.new)
}.freeze

run Rack::URLMap.new(ROUTES)
