# frozen_string_literal: true

module SchemaRegistry
  class Loader
    def initialize(schemas_root_path:)
      @schemas_root_path = schemas_root_path
    end

    def schema_path(name, version:)
      path = name.tr('.', '/')
      File.join(schemas_root_path, "#{path}/#{version}.json")
    end

    private

    attr_reader :schemas_root_path
  end
end
