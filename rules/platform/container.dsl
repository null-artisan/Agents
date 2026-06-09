# Container DSL
# Purpose: Docker and containerization conventions for all projects
# All projects under this governance system use Docker Compose for local development and production deployment.

rule docker_compose:
  priority=medium
  required=Docker Compose v2 for local service orchestration
  required=define health checks for all services (healthcheck in compose)
  required=use named volumes for persistent data (postgres_data, uploads_data, etc.)
  required=pin major/minor image tags (postgres:16-alpine, not postgres:latest)
  preferred=.env file for environment-specific overrides
  forbidden=hard-coding secrets in docker-compose.yml

rule dockerfile_best_practices:
  priority=medium
  required=multi-stage builds for compiled languages (Go, Rust, Java)
  required=use distroless or alpine runtime images for production
  required=use .dockerignore to exclude node_modules, .git, and build artifacts
  preferred=pin base image digests in production Dockerfiles
  forbidden=running containers as root in production

rule service_dependency_ordering:
  priority=medium
  required=declare depends_on with condition: service_healthy for database dependencies
  required=backend waits for database to be healthy before starting
  required=frontend waits for backend to be healthy (or handles gracefully)
  note=health check conditions prevent race conditions on startup

rule hot_reload:
  priority=medium
  required=development services support hot-reload (vite dev, nodemon, air for Go)
  required=bind mount source code in development compose overrides
  forbidden=rebuilding image on every code change during development

rule resource_limits:
  priority=low
  preferred=set memory and CPU limits in production docker-compose.override.yml
  preferred=use --memory-reservation for guaranteed minimum

rule compose_production:
  priority=medium
  preferred=separate docker-compose.yml (base) and docker-compose.prod.yml (production overrides)
  required=production compose removes port bindings to host for backend services
  required=production compose uses restart: unless-stopped or restart: always
  required=production compose sets log rotation limits
