require 'water_drop'
require 'water_drop/sync_producer'

WaterDrop.setup do |config|
  config.deliver = true
  config.kafka.seed_brokers = [ENV['KAFKA_URL']]
  # config.kafka.seed_brokers = ['kafka://198.163.0.68:9092']
end
