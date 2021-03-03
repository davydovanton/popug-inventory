# Event schema registry

This repository is an example of how to make event schema registry for JSON schema events using only github. The general idea - how to share schemas across different services plus how to validate data for specific events.

## Setup
### Ruby
Add this line into your Gemfile:

```
gem "schema_registry", git: "https://github.com/davydovanton/event_schema_registry.git"
```

## How to add a new event schema

For example, you want to create `billing.refund` event. For make it happen you need:

1. Create a new file `domain/event_name/version.json` in `schemas/` folder. For `billing.refund` it will be `schemas/billing/refund/1.json` (because all new events should be first version;
2. Create a new json schema file like this:

```
{
  "$schema": "http://json-schema.org/draft-04/schema#",

  "title": "Billing.Refund.v1",
  "description": "json schema for billing refund event (version 1)",

  "definitions": {
    "event_data": {
      "type": "object",
      "properties": {
        // event specific information here
      },
      "required": [
      ]
    }
  },

  "type": "object",

  "properties": {
    "event_id":      { "type": "string" },
    "event_version": { "enum": [1] },
    "event_name":    { "type": "string" },
    "event_time":    { "type": "string" },
    "producer":      { "type": "string" },

    "data": { "$ref": "#/definitions/event_data" }
  },

  "required": [
    "event_id",
    "event_version",
    "event_name",
    "event_time",
    "producer",
    "data"
  ]
}
```

## How to validate an event data by specific schema

### Ruby

For validating event data you need to use `SchemaRegistry#validate_event` method with following options:

* `data` - event data
* `name` - name of event which you will use for getting schema
* `version` - version of event data schema (default `1`)

Example:

```ruby
message = {
  # ...
}

# will try to search `schemas/Billing/CompliteCycle/1.json` file
result = SchemaRegistry.validate_event(data, 'Billing.CompliteCycle', version: 1)
# will try to search `schemas/billing/complite_cycle/1.json` file
result = SchemaRegistry.validate_event(data, 'billing.complite_cycle', version: 1)

# After you can work with result object
result.success?
result.failure?
result.failure
```

## How to use this library with producer
### Option one: with event object
```ruby
result = SchemaRegistry.validate_event(event, 'billing.refund', version: 1)

if result.success?
  kafka.produce('topic', event.to_json)
end
```

### Option two: with pure hash
```ruby
result = SchemaRegistry.validate_event(event, 'billing.refund', version: 1)

if result.success?
  kafka.produce('topic', event.to_json)
end
```
