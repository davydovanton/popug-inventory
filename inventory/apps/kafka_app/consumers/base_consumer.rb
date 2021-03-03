# frozen_string_literal: true

# Application consumer from which all Karafka consumers should inherit
# You can rename it if it would conflict with your current code base (in case you're integrating
# Karafka with other frameworks)
module KafkaApp
  module Consumers
    class Base < Karafka::BaseConsumer
    end
  end
end
