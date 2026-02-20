# Parametrizaciones Microservice

Centralized parameter management for ERP microservices.

## Architecture
- **Hexagonal Architecture**: Separation of Domain, Application, and Infrastructure.
- **REST API**: Secure endpoints for parameter management and lookup.
- **RabbitMQ**: Messaging for real-time parameter synchronization.
- **MySQL**: Relational storage with Flyway for version control.

## Integration Strategy: creditos-web

### 1. Initial Load
On startup, `creditos-web` should call:
`GET /api/parameters/creditos-web`
and cache the resulting parameters.

### 2. Real-time Updates
`creditos-web` must listen to the `parametrizaciones.exchange` with a routing key like `parameter.updated.creditos-web`.

**Sample Listener implementation in `creditos-web`**:
```java
@RabbitListener(queues = "creditos-web.param.queue")
public void handleParameterUpdate(ParameterUpdatedEvent event) {
    log.info("Updating local cache for key: {}", event.getKey());
    parameterCache.put(event.getKey(), event.getValue());
}
```

### 3. Caching & Consistency
- **Cache**: Use a `ConcurrentHashMap` or a distributed cache like Redis.
- **Consistency**: The `version` and `signature` in the event ensure that updates are applied in order and are idempotent.
- **Fallback**: If the messaging system is down, services can query the REST API directly.

## Security
- JWT authentication required.
- `ADMIN` role required for any POST/PUT/DELETE operations.
- Deny-by-default configuration.

## API Endpoints
- `GET /api/parameters/{service}`: List all parameters for a service.
- `GET /api/parameters/{service}/{key}`: Get a specific parameter.
- `POST /api/parameters`: Create new parameter (ADMIN).
- `PUT /api/parameters/{id}`: Update parameter (ADMIN).
- `DELETE /api/parameters/{id}`: Soft-delete parameter (ADMIN).
