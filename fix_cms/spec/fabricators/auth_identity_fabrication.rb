# frozen_string_literal: true

Fabricator(:auth_identity) do
  account_id { Fabricate(:account).id }

  uid '123asb'
  token 'TestToken'
  provider 'github'
  login 'davydovanton'
  password_hash nil

  avatar_url 'https://pbs.twimg.com/media/EWBcj25XYAAfcSQ?format=jpg&name=medium'
end
