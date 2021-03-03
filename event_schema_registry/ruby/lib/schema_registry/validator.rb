# frozen_string_literal: true

begin
  require 'dry/monads'
rescue LoadError
end

module SchemaRegistry
  class Result
    attr_reader :result

    def initialize(validation_result)
      @result = validation_result
    end

    def success?
      result.empty?
    end

    def failure?
      result.any?
    end

    def failure
      result
    end

    def something
      result
    end

    def ==(other)
      self.result == other.result
    end
  end

  class Validator
    def initialize(loader:)
      @loader = loader
    end

    attr_reader :loader

    def validate(data, type, version: 1)
      schema_path = loader.schema_path(type, version: version)
      result = JSON::Validator.fully_validate(schema_path, data)

      # TODO: use monads instead result object if gem was defined
      if defined?(Dry::Monads::Result::Success)
        result.empty? ? Dry::Monads::Result::Success.new(result) : Dry::Monads::Result::Failure.new(result)
      else
        Result.new(result)
      end
    end
  end
end
