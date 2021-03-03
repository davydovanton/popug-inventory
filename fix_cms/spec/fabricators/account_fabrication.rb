# frozen_string_literal: true

Fabricator(:account) do
  name 'Anton'
  email 'test@inventarium.io'
  uuid { SecureRandom.uuid }

  avatar_url 'https://pbs.twimg.com/media/EWBcj25XYAAfcSQ?format=jpg&name=medium'
end
