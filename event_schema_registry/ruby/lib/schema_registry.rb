# frozen_string_literal: true

require 'json'
require 'json-schema'

require_relative 'schema_registry/loader'
require_relative 'schema_registry/validator'

# Validates event schema
#
#   SchemaRegistry.validate_event(event_hash, 'order.refund')
#
module SchemaRegistry
  # Method for validate event data by specific schema
  #
  # @param data [Hash] raw event data
  # @param type [String] a name of the schema
  # @param version [Integer] version of event schema
  #
  # @return [<SchemaRegistry::Result>] Result object with list of validation errors or an empty list if schema is valid
  def self.validate_event(data, type, version: 1)
    validator.validate(
      data,
      type,
      version: version
    )
  end

  def self.validator
    @validator ||= Validator.new(loader: loader)
  end

  def self.loader
    @loader ||= Loader.new(schemas_root_path: File.expand_path('../../schemas', __dir__))
  end
end
