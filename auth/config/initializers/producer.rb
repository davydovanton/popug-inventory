class Producer
  def call(event, topic:)
    case ENV['BROKER_ADAPTER']
    when 'kafka'
      WaterDrop::SyncProducer.call(event.to_json, topic: topic)
    when 'rabbitmq'
      send_rabbitmq_event(event, topic)
    end
  end

private

  def send_rabbitmq_event(event, topic)
    require 'bunny'

    connection = Bunny.new(ENV['AMQP_URL'])
    connection.start

    get_rabbitmq_exchange(connection.create_channel, topic).publish(event.to_json)

    connection.close
  end

  def get_rabbitmq_exchange(channel, topic)
    channel.find_exchange(topic) || channel.fanout(topic)
  end
end
