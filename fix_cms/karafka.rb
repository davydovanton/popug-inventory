# frozen_string_literal: true

# Non Ruby on Rails setup
ENV['RACK_ENV'] ||= 'development'
ENV['KARAFKA_ENV'] ||= ENV['RACK_ENV']
Bundler.require(:default, ENV['KARAFKA_ENV'])
# Karafka::Loader.load(Karafka::App.root)
require 'json'
require 'active_support/core_ext/hash'
require './config/boot'

Dir[
  'apps/kafka_app/consumers/*.rb'
].each {|file| require_relative file }

#------------------------------------------------------

class JsonDeserializer
  def self.parse(message)
    JSON.parse(message)
  end
end

#------------------------------------------------------

# App class
# @note The whole setup and routing could be placed in a single class definition
#   but we wanted to show you, that in case of bigger applications, you can create
#   a structure similar to rails config/routes.rb, etc.
class App < Karafka::App
  setup do |config|
    # Karafka will autodiscover kafka_hosts based on Zookeeper but we need it set manually
    # to run tests without running kafka and zookeper
    config.kafka.seed_brokers = %w[kafka://192.168.1.67:9092]
    config.client_id = 'fix_cms_service'
    config.backend = :inline
    config.batch_fetching = true
    # Enable those 2 lines if you use Rails and want to use hash with indifferent access for
    # Karafka params
    # require 'active_support/hash_with_indifferent_access'
    # config.params_base_class = HashWithIndifferentAccess
  end

  after_init do
    WaterDrop.setup { |config| config.deliver = !Karafka.env.test? }
  end
end

Karafka.monitor.subscribe(Karafka::Instrumentation::Listener)

# Consumer group defined with the 0.6+ routing style (recommended)
App.consumer_groups.draw do
  # consumer_group :notifications do
  #   topic :'accounts-stream' do
  #     consumer KafkaApp::Consumers::MyTopic
  #     parser JsonDeserializer
  #   end
  #
  #   topic :'accounts' do
  #     consumer KafkaApp::Consumers::MyTopic
  #     parser JsonDeserializer
  #   end
  # end

  consumer_group :real_work do
    topic :'accounts-stream' do
      consumer KafkaApp::Consumers::AccountChanges
      parser JsonDeserializer
    end

    topic :'accounts' do
      consumer KafkaApp::Consumers::AccountChanges
      parser JsonDeserializer
    end

    topic :'items-stream' do
      consumer KafkaApp::Consumers::NewItems
      parser JsonDeserializer
    end

    topic :'broken-items' do
      consumer KafkaApp::Consumers::BrokenItem
      parser JsonDeserializer
    end
  end
end

App.boot!
