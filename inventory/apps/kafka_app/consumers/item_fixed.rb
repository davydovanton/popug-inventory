require_relative './base_consumer'

module KafkaApp
  module Consumers
    class ItemsFixed < Base
      def consume
        params_batch.each do |message|
          puts '-' * 80
          p message
          puts '-' * 80

          case message['event_name']
          when 'ItemsFixed'
            # validate data by schema
            # if valid?
            #   call BL
            # else
            #   Store event in BD
            #   produce invalid event to 'invalid-events-topic'
            # end
            item_repo.fix(
              message['data']['public_id'],
              meta: {
                repairman_public_id: message['data']['repairman_public_id']
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
