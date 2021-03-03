# frozen_string_literal: true

module Auth
  module Controllers
    module OauthSession
      class Destroy
        include Auth::Action

        def call(_params)
          session[:account] = nil
          redirect_to routes.login_path
        end
      end
    end
  end
end
