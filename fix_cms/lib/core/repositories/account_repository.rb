# frozen_string_literal: true

class AccountRepository < Hanami::Repository
  associations do
    has_many :auth_identities
  end

  def find_by_auth_identity(provider, auth_identity)
    # TODO: here is an issue when one user created account with github,
    #       but when he tried to use google as a auth_identity he will create one more account
    root
      .join(auth_identities)
      .where(auth_identities[:provider] => provider)
      .where(auth_identities[:login] => auth_identity[:login])
      .map_to(Account).one
  end

  def create_with_identity(provider, account, auth_identity)
    assoc(:auth_identities).create(
      **account,
      auth_identities: [{ **auth_identity, provider: provider }]
    )
  end

  def update_by_public_id(public_id, payload)
    transaction do
      account = root.where(public_id: public_id).one
      return unless account

      update(account.id, payload)
      account
    end
  end
end
