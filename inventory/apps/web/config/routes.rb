# frozen_string_literal: true

# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
root to: 'items#index'

resource :items, only: [:new, :create]
resource :book_items, only: [:create, :destroy]
resource :item_issues, only: [:create]
