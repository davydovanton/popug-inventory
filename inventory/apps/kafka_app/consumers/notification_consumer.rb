class NotificationConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      # only user related notifications
      case message['event_name']
      when 'ItemCreated'
        # send notification to the email of account who want to get this item
      when 'ItemsFixed'
        # send notification to the email of account who told about broken item
      else
        # do nothing
      end
    end
  end
end
