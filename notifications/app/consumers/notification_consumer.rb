class NotificationConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      # only business related notifications
      #
      # User specific notifications you can find in other services
      
      case message['event_name']
      when 'ItemsBroken'
        # send notification to the slack channel
      when 'ItemsFixed'
        # send notification to the slack channel
      when 'AccountRoleChanged'
        # send notification to the slack channel
      else
        # do nothing
      end
    end
  end
end
