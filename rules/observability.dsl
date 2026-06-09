# Observability DSL
# Purpose: Metrics (RED), structured logging, distributed tracing, alerting, OpenTelemetry conventions
# Consolidates observability governance previously scattered across architecture.dsl, security.dsl,
# backend-go.dsl, and backend-spring.dsl

rule red_metrics:
  priority=medium
  trigger=project in production or staging with live traffic
  required=every service exposes RED metrics: Rate (req/s), Errors (error rate %), Duration (p50/p95/p99)
  required=P95 latency <= 400ms for interactive endpoints, P99 <= 1s
  required=standardized label schema: service_name, team, environment
  preferred=instrument at service entry point for accurate request counting
  preferred=RED metrics exported to a centralized metrics store (Prometheus, Datadog, Grafana)
  note=RED metrics cover the three pillars of service-level monitoring without over-collection
  skip=development, prototype, or pre-release projects

rule structured_logging:
  priority=medium
  required=all logs are structured JSON format
  required=minimum fields: timestamp, level, message, service_name, request_id, trace_id, caller, duration_ms
  forbidden=unstructured log strings
  preferred=include user_id for authenticated requests
  preferred=use consistent key naming (snake_case) across all services

rule trace_propagation:
  priority=medium
  trigger=project in production with 3+ microservices
  required=OpenTelemetry instrumentation for all services
  required=trace context propagated across all service boundaries (W3C traceparent header)
  required=trace_id in every log entry for correlation
  preferred=export traces to a distributed tracing backend (Jaeger, Tempo, Datadog APM)
  preferred=instrument database calls, HTTP clients, and message queue producers/consumers
  note=trace context must survive async boundaries (goroutines, threads, message queues)
  skip=monolith, prototype, or single-service projects
  see=backend-go.dsl request_id_propagation  # Go-specific; equivalent patterns exist for other backends

rule alerting:
  priority=medium
  trigger=project in production with on-call rotation
  required=alert on symptoms (high error rate), not causes (high CPU)
  required=every alert includes: severity, description, runbook link, team label
  preferred=burn-rate alerting based on SLOs
  preferred=define SLOs for critical service paths before configuring alerts
  preferred=use alert routing based on team label for on-call rotation
  note=multi-window, multi-burn-rate alerts reduce noise while catching real issues fast
  forbidden=dead man threshold alerts without actionable response steps
  review=during incident review: check if alert fired early enough and with sufficient context
  skip=pre-production projects without on-call

rule health_checks:
  priority=medium
  required=every service exposes: /healthz (liveness) and /readyz (readiness)
  required=readiness checks DB connectivity and critical dependencies
  required=health check endpoints are exempt from authentication but rate-limited
  preferred=include version and build info in health response metadata
  note=/healthz should be lightweight (process alive); /readyz should be deeper (dependencies ready)
  see=platform/backend-go.dsl health_check_depth

rule telemetry_cost:
  priority=low
  preferred=100% sampling for errors, ~10% for success traces (tail sampling)
  preferred=log retention: hot tier 15d, warm 90d, cold 1y
  preferred=metrics retention: raw 30d, aggregated 1y
  note=head sampling loses error context; tail-based sampling preserves it
  action=review sampling rates quarterly against trace volume and budget

rule dashboard_conventions:
  priority=medium
  preferred=every service has a dashboard showing RED metrics, logs panel, and recent alerts
  preferred=dashboard naming: [Service Name] - [Tier] (e.g., "Payment API - Production")
  forbidden=dashboard sprawl: one canonical dashboard per service per environment
