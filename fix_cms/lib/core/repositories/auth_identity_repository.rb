# frozen_string_literal: true

class AuthIdentityRepository < Hanami::Repository
  associations do
    belongs_to :account
  end
end
