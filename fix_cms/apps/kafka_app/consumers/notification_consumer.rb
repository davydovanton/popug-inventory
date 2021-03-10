class NotificationConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      # only user related notifications
      
      case message['event_name']
      when 'ItemsBroken'
        # send notification to the slack channel of ppl who can fix item
      else
        # do nothing
      end
    end
  end
end
