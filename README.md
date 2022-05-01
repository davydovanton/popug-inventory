# Popug Inventory app

Code example for ["Асинхронная архитектура" course](http://education.borshev.com/architecture)

If you need to change topics (in kafka) or queues/exchanges in rabbitmq - just send a message in the chat (site or telegram).

## Topics and events

- `accounts-stream` Topic/Exchange, `AccountCreated` event (https://github.com/davydovanton/popug-inventory/blob/separate-auth-service-in-docker/event_schema_registry/schemas/accounts/created/1.json)
- `accounts-stream` Topic/Exchange, `AccountUpdated` event (https://github.com/davydovanton/popug-inventory/blob/separate-auth-service-in-docker/event_schema_registry/schemas/accounts/updated/1.json)
- `accounts-stream` Topic/Exchange, `AccountDeleted` event (https://github.com/davydovanton/popug-inventory/blob/separate-auth-service-in-docker/event_schema_registry/schemas/accounts/deleted/1.json)
- `accounts` Topic/Exchange, `AccountRoleChanged` event (https://github.com/davydovanton/popug-inventory/blob/separate-auth-service-in-docker/event_schema_registry/schemas/accounts/role_changed/1.json)

## Routes

- `localhost:3000` - main
- `localhost:3000/oauth/applications` - oauth app managment

## How to start oAuth with kafka broker

```
cd ./docker-composes/kafka/
docker-compose build

docker network create popug-jira

docker-compose run oauth rake db:create
docker-compose run oauth rake db:migrate

docker-compose up
```

## How to start oAuth with rabbitmq broker

```
cd ./docker-composes/rabbitmq/
docker-compose build

docker-compose run oauth rake db:create
docker-compose run oauth rake db:migrate

docker-compose up
```
