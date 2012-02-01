require 'rack/cache'
require './yesorno'

use Rack::Cache,
  :verbose     => true
  
run Sinatra::Application