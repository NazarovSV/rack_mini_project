require_relative 'app'
require_relative 'middleware/logger'
require_relative 'middleware/request_handler'

use AppLogger, logdev: File.expand_path('log/app.log', __dir__)
use RequestHandler, delimiter: ','
run App.new
