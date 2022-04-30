# frozen_string_literal: true

# This file is auto-generated during the install process.
# If by any chance you've wanted a setup for Rails app, either run the `karafka:install`
# command again or refer to the install templates available in the source codes

ENV['RACK_ENV'] ||= 'development'
ENV['KARAFKA_ENV'] ||= ENV['RACK_ENV']
Bundler.require(:default, ENV['KARAFKA_ENV'])

# Zeitwerk custom loader for loading the app components before the whole
# Karafka framework configuration
APP_LOADER = Zeitwerk::Loader.new
APP_LOADER.enable_reloading

%w[
  app/consumers
  app/responders
].each(&APP_LOADER.method(:push_dir))

APP_LOADER.setup
APP_LOADER.eager_load


#------------------------------------------------------

class EmptyDeserializer
  def call(message)
    message.payload
  end
end

#------------------------------------------------------

class KarafkaApp < Karafka::App
  setup do |config|
    config.kafka.seed_brokers = %w[kafka://192.168.1.68:9092]
    config.client_id = 'notification_service'
    config.backend = :inline
    config.batch_fetching = true
  end

  # Comment out this part if you are not using instrumentation and/or you are not
  # interested in logging events for certain environments. Since instrumentation
  # notifications add extra boilerplate, if you want to achieve max performance,
  # listen to only what you really need for given environment.
  Karafka.monitor.subscribe(WaterDrop::Instrumentation::StdoutListener.new)
  Karafka.monitor.subscribe(Karafka::Instrumentation::StdoutListener.new)
  Karafka.monitor.subscribe(Karafka::Instrumentation::ProctitleListener.new)

  # Uncomment that in order to achieve code reload in development mode
  # Be aware, that this might have some side-effects. Please refer to the wiki
  # for more details on benefits and downsides of the code reload in the
  # development mode
  #
  # Karafka.monitor.subscribe(
  #   Karafka::CodeReloader.new(
  #     APP_LOADER
  #   )
  # )

  consumer_groups.draw do
    consumer_group :topic_group do
      topic :'accounts-stream' do
        consumer MyTopicConsumer
        deserializer EmptyDeserializer.new
      end

      topic :'accounts' do
        consumer MyTopicConsumer
        deserializer EmptyDeserializer.new
      end

      topic :'items-stream' do
        consumer MyTopicConsumer
        deserializer EmptyDeserializer.new
      end

      topic :'broken-items' do
        consumer MyTopicConsumer
        deserializer EmptyDeserializer.new
      end

      topic :'item-statuses' do
        consumer MyTopicConsumer
        deserializer EmptyDeserializer.new
      end
    end
  end
end

Karafka.monitor.subscribe('app.initialized') do
  # Put here all the things you want to do after the Karafka framework
  # initialization
end

KarafkaApp.boot!
