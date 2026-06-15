# Step 1: Infrastructure & Environment Setup

## Objective
Set up the foundational infrastructure for the new Go + Flutter architecture using Docker Compose, Dapr, and Redis.

## Tasks
- [ ] **Docker Compose Setup**: Create a `docker-compose.yml` file at the root of the backend project.
- [ ] **Redis Container**: Configure a Redis instance (image `redis:7`) to act as the state store and Pub/Sub broker for Dapr.
- [ ] **Dapr Sidecar Configuration**: Set up the Dapr sidecar in the Docker Compose file to interface with the Go backend.
- [ ] **Firebase Admin Setup**: Ensure the `GOOGLE_APPLICATION_CREDENTIALS` environment variable is mapped correctly in the Docker Compose file, pointing to the `firebase-key.json`.
- [ ] **Dapr Components**: Create a `components` directory for Dapr configuration files (e.g., `pubsub.yaml`, `statestore.yaml`) to map to the Redis container.

## Expected Outcome
A running local environment where Redis and Dapr are operational, ready to attach to the Go microservices.
