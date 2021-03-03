# frozen_string_literal: true

# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
get '/login', to: 'signin#index', as: 'login'
get '/logout', to: 'oauth_session#destroy'
get '/auth/:provider/callback', to: 'oauth_session#create'
