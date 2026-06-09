# Backend Spring Platform DSL
# Purpose: Java Spring Boot conventions with JPA, QueryDSL, Security — exception handling, transactions,
#          API versioning, health check depth, connection pool

rule framework:
  priority=medium
  required=Spring Boot for application framework
  required=latest LTS version
  preferred=Gradle or Maven with Spring Boot Starter parent

rule persistence:
  priority=medium
  required=JPA with Hibernate for ORM
  required=QueryDSL for compile-time query safety
  forbidden=raw JDBC without abstraction layer

rule security:
  priority=medium
  required=Spring Security for authentication and authorization
  required=method-level security with @PreAuthorize / @PostAuthorize

rule validation:
  priority=medium
  required=Bean Validation annotations (@Valid, @NotBlank, etc.)
  required=validate at controller boundary

rule testing:
  priority=medium
  see=testing.dsl  # framework_selection rule covers JUnit 5 + Mockito
  preferred=@WebMvcTest for controller layer
  preferred=@DataJpaTest for repository layer

rule code_quality:
  priority=medium
  allowed=Lombok (@Data, @Builder, @Slf4j)
  allowed=MapStruct for entity-DTO mapping
  forbidden=circular dependencies between layers

rule exception_handling:
  priority=medium
  required=use @ControllerAdvice or @RestControllerAdvice for global exception handling
  required=return consistent error response format (error code, message, timestamp, request_id)
  preferred=define specific exception handlers for common types (EntityNotFound, MethodArgumentNotValid, etc.)
  forbidden=leaking framework-specific exception details to client

rule transaction_conventions:
  priority=medium
  required=annotate service layer methods with @Transactional for write operations
  required=use readOnly=true on @Transactional for read-only queries
  required=keep transaction boundaries at service layer, not controller layer
  forbidden=opening transactions in view templates or presentation layer

rule api_versioning:
  priority=medium
  required=prefix API paths with version (/v1/, /v2/)
  required=maintain backward compatibility within the same major version
  preferred=deprecate old versions with Sunset header
  note=URL path versioning is explicit and easier to route than header-based versioning

rule health_check_depth:
  priority=medium
  see=observability.dsl health_checks
  required=configure Spring Boot Actuator to expose /healthz (liveness, basic health) and /readyz (readiness, dependency checks) matching observability.dsl standard
  required=enrich /readyz with custom health indicators for critical dependencies
  note=shallow health checks pass while the application is actually broken

rule db_connection_pool:
  priority=medium
  required=configure HikariCP pool limits (maximumPoolSize, minimumIdle, idleTimeout, maxLifetime)
  required=set maxLifetime to less than database server's connection timeout (typically < 30 minutes)
  preferred=start with maximumPoolSize = 25, adjust based on load testing
  note=connection pool exhaustion is a common production failure mode
