class MyTopicConsumer < ApplicationConsumer
  def consume
    puts '*' * 80

    params_batch.each do |message|
      puts
      puts message['payload']
      puts
      puts message
      puts
    end
  end
end
