module KafkaApp
  module Consumers
    class MyTopic < Base
      def consume
        puts '*' * 80

        params_batch.each do |message|
          puts
          puts message
          puts
        end
      end
    end
  end
end
