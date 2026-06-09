# Backend Go Platform DSL
# Purpose: Go backend conventions with Gin, GORM, ecosystem — API responses, middleware, graceful shutdown,
#          request tracing, health check depth, connection pool

rule framework:
  priority=medium
  required=Gin for HTTP routing and middleware
  preferred=standard project layout (cmd/, internal/, pkg/)

rule storage:
  priority=medium
  required=GORM for database ORM
  allowed=raw SQL for complex queries (via GORM sql.Raw or sqlx)

rule configuration:
  priority=medium
  required=Viper for configuration management
  supported=sources: environment variables, config files, remote config

rule logging:
  priority=medium
  required=zap for structured logging
  see=security.dsl  # logging_security rule covers log levels and sensitive data restrictions

rule validation:
  priority=medium
  required=go-playground/validator for struct validation
  required=validate all external input at handler layer

rule authentication:
  priority=medium
  required=golang-jwt/jwt for JWT token handling
  required=use httpOnly cookies for token storage
  preferred=short-lived access tokens with refresh token rotation

rule authorization:
  priority=medium
  required=casbin for role-based and attribute-based access control

rule performance:
  priority=medium
  target=P95 response time <= 200ms
  target=database queries <= 50ms
  required=/healthz endpoint for liveness probe
  required=/readyz endpoint for readiness probe

rule api_response_envelope:
  priority=medium
  required=use consistent JSON response envelope: { data, error, status }
  required=data field for successful responses, error field for failures
  required=include request_id or trace_id in every response for debugging
  preferred=paginated responses include total, page, per_page in the envelope

rule middleware_chain:
  priority=medium
  required=define explicit middleware order: recovery → requestID → logger → cors → auth → rate_limit → handler
  required=add request ID middleware early in the chain (before logger)
  note=middleware ordering affects behavior; auth before rate_limit prevents unauthenticated rate limit consumption

rule graceful_shutdown:
  priority=medium
  required=handle SIGTERM and SIGINT for clean server shutdown
  required=drain active connections before exiting within a configurable timeout
  required=close database connections and release resources during shutdown
  preferred=log shutdown progress at each stage

rule request_id_propagation:
  priority=medium
  required=generate unique request ID for every incoming request
  required=propagate request ID to downstream service calls (gRPC metadata or HTTP headers)
  required=include request ID in all log entries for that request
  note=request ID enables end-to-end tracing across service boundaries

rule health_check_depth:
  priority=medium
  see=observability.dsl health_checks
  required=/healthz endpoint must verify database connectivity (ping) at minimum
  preferred=/healthz should verify downstream service health, disk space, and memory pressure
  required=/readyz endpoint must verify application is fully initialized and migrations are complete
  note=shallow health checks pass while the application is actually broken
  note=endpoint names standardized with observability.dsl: /healthz (liveness), /readyz (readiness)

rule db_connection_pool:
  priority=medium
  required=configure GORM connection pool limits (SetMaxOpenConns, SetMaxIdleConns, SetConnMaxLifetime)
  required=set ConnMaxLifetime to prevent stale connections (typically < 60 minutes)
  preferred=start with max_open = 25, max_idle = 10, adjust based on load testing
  note=connection pool exhaustion is a common production failure mode
