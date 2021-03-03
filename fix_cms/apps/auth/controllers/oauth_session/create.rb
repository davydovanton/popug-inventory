# frozen_string_literal: true

module Auth
  module Controllers
    module OauthSession
      class Create
        include Auth::Action
        include Dry::Monads::Result::Mixin

        include Import[
          operation: 'accounts.operations.create_by_oauth'
        ]

        VALID_ROLES = ['admin', 'repairman'].freeze

        def call(params) # rubocop:disable Metrics/MethodLength
          unless VALID_ROLES.include?(request.env['omniauth.auth']['info']['role'])
            redirect_to routes.login_path
          end

          result = operation.call(
            provider: params[:provider].to_s,
            payload: request.env['omniauth.auth']
          )

          case result
          when Success
            session[:account] = result.value!
            redirect_to '/'
          when Failure
            redirect_to routes.login_path
          end
        end
      end
    end
  end
end
