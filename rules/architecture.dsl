# Architecture DSL
# Purpose: Layer separation, API contracts, naming, abstraction, readability, repository structure,
#          dependencies, documentation, error handling, configuration layering, logging field standard,
#          startup validation

rule layer_separation:
  priority=medium
  required=FE and BE physically separated (different packages/projects)
  required=define API contract before implementation
  forbidden=cross-layer logic in single PR
  preferred=API-first design

rule api_design:
  priority=medium
  required=RESTful: GET, POST, PUT, DELETE
  required=nouns over verbs (/users not /getUser)
  required=proper HTTP status codes
  required=camelCase JSON keys
  preferred=OpenAPI/Swagger spec for public APIs (code-first or spec-first)

rule srp_no_god_objects:
  priority=medium
  trigger=function exceeds 50 lines or name contains "and"
  action=evaluate whether splitting improves clarity
  required=one clear purpose per function
  review=check for oversized functions during code review

rule abstraction_limit:
  priority=medium
  preferred=no abstraction until pattern appears twice
  forbidden=unrequested flexibility or speculative abstraction
  see=lessons/ai_failures.dsl over_engineering
  allowed=readability refactoring within scope

rule readability:
  priority=medium
  required=code intent graspable within 3 seconds
  forbidden=nesting exceeding 3 levels
  preferred=simple over clever
  preferred=concise but not compressed
  review=check for unnecessary complexity during code review

rule naming_conventions:
  priority=medium
  required=camelCase for variables and functions
  required=PascalCase for classes, types, components
  required=UPPER_SNAKE_CASE for constants
  required=snake_case for file names
  required=English for all code identifiers

rule repository_structure:
  priority=medium
  preferred=monorepo for single-product with shared types
  trigger=team grows beyond 8 members
  action=consider splitting into separate repositories
  required=commit lock files
  required=CI uses frozen installs
  preferred=internal packages prefixed with @workspace/

rule dependency_policy:
  priority=medium
  preferred=use existing files and libraries over new ones
  required=minimize new dependencies
  required=check license before adding dependency
  forbidden=copyleft license without user approval
  forbidden=copying external source code verbatim

rule documentation:
  priority=medium
  required=public APIs need OpenAPI/Swagger spec (same PR as implementation)
  required=comments document connections: where called from, where it connects to
  required=README comprehensible in 30 seconds
  preferred=examples over explanations in README

rule configuration_layering:
  priority=medium
  required=define clear config precedence: CLI flags > env vars > config file > defaults
  required=use separate config sets per environment (dev, staging, production)
  required=keep secrets out of config files (use env vars or secrets manager)
  forbidden=hard-coding environment-specific values in default config files
  note=environment-specific config should extend defaults, not duplicate them

rule logging_field_standard:
  priority=medium
  see=observability.dsl structured_logging  # single source of truth for minimum field requirements
  required=include user_id in log entries for authenticated requests
  preferred=structured JSON format for automated log aggregation
  note=standardized log fields enable correlation, debugging, and alerting across services

rule config_startup_validation:
  priority=high
  required=validate all required configuration values at application startup
  required=fail fast (exit with non-zero code) if required config is missing or invalid
  required=log clear error message identifying the specific missing or invalid configuration key
  note=silent misconfiguration in production is harder to diagnose than a startup crash
