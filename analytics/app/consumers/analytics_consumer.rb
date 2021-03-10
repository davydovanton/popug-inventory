class AnalyticsConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      # store all events into analytics DB with specific format
      
      # TODO: write data analytics related code here
    end
  end
end
