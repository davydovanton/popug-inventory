# frozen_string_literal: true

require './config/environment'

use Rack::Session::Cookie, secret: Container[:settings].web_sessions_secret

run Hanami.app
