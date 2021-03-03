module KafkaApp
  module Consumers
    class AccountChanges < Base
      def consume
        params_batch.each do |message|
          case [message['event_name'], message['event_version']]
          when 'AccountCreated'
            # TODO: if you want
          when ['AccountUpdated', 1]
            account_repo.update_by_public_id(
              message['data']['public_id'],
              full_name: message['data']['full_name'],
              position: message['data']['position']
            )
          when ['AccountUpdated', 2]
            # TODO: something else
          when 'AccountDeleted'
            # TODO: if you want
          when 'AccountRoleChanged'
            account_repo.update_by_public_id(message['data']['public_id'], role: message['data']['role'])
          else
            # store events in DB
          end
        end
      end

      def account_repo
        Container['repositories.account']
      end
    end
  end
end
