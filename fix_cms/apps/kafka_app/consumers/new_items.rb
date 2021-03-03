require_relative './base_consumer'

module KafkaApp
  module Consumers
    class NewItems < Base
      def consume
        params_batch.each do |message|
          puts '-' * 80
          p message
          puts '-' * 80

          case [message['event_name'], message['event_version']]
          when ['ItemsCreated', 1]
            account_repo.create(
              public_id: message['data']['public_id'],
              title: message['data']['title'],
              status: 'new'
            )
          when ['ItemsCreated', 2]
          else
            # store events in DB
          end
        end
      end

      def account_repo
        Container['repositories.item']
      end
    end
  end
end
