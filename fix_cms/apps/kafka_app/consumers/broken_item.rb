require_relative './base_consumer'

module KafkaApp
  module Consumers
    class BrokenItem < Base
      def consume
        params_batch.each do |message|
          puts '-' * 80
          p message
          puts '-' * 80

          case message['event_name']
          when 'ItemsBroken'
            item_repo.update_broken_status(
              message['data']['public_id'],
              meta: {
                requester_public_id: message['data']['requester_public_id']
              }
            )
          else
            # store events in DB
          end
        end
      end

      def item_repo
        Container['repositories.item']
      end
    end
  end
end
