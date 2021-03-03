# frozen_string_literal: true

module Accounts
  module Operations
    class CreateByOauth < ::Libs::Operation
      include Import[
        repo: 'repositories.account'
      ]

      def call(provider:, payload:)
        account = repo.find_by_auth_identity(provider, auth_identity_params(payload))

        if account.nil?
          account = yield persist(provider, payload)

          # TODO: send something for new created account
        end

        Success(account)
      end

      private

      def persist(provider, payload) # rubocop:disable Metrics/MethodLength
        Success(
          repo.create_with_identity(
            Core::Types::AuthIdentityProvider[provider],
            account_params(payload),
            auth_identity_params(payload)
          )
        )
      rescue Dry::Types::ConstraintError
        Failure(:invalid_provider)
      rescue Hanami::Model::UniqueConstraintViolationError, Hanami::Model::NotNullConstraintViolationError
        Failure(:invalid_payload)
      end

      def account_params(payload)
        {
          public_id: payload['info']['public_id'],
          full_name: payload['info']['full_name'],
          email: payload['info']['email'],
          role: payload['info']['role'],
        }
      end

      def auth_identity_params(payload)
        {
          uid: payload['uid'],
          token: payload['credentials']['token'],
          login: payload['info']['email']
        }
      end
    end
  end
end
