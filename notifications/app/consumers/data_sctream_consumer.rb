class DataStreamConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      case message['event_name']
      when 'ItemCreated'
        # store new item aggregates
      when 'AccountCreated'
        # store new account aggregates
      when 'AccountUpdated'
        # store changed account aggregates
      end
    end
  end
end
