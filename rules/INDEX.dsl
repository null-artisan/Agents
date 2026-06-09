# DSL Index
# Single source of truth for DSL discovery, categorization, load order, and enablement.
# Priority mapping: high = Constitution P0 (Never Violate), medium = Constitution P1 (Ask Before Proceeding), low = Constitution P2 (Preferred Behavior)
#   IMPORTANT: This mapping IS the enforcement contract. See AGENTS.md #Priority-Levels and governance/maintenance.dsl priority_mapping_enforcement.
#   When adding a new rule: match DSL priority to the intended Constitution tier. Do NOT use "P0"/"P1"/"P2" as DSL priority values.
# Load order: categories load in ascending load_order. Files load top-to-bottom within each category.
# Enablement: set enabled=false to exclude a file without deleting it.
# Only DSL files listed here are considered loadable per Constitution Rule Loading.

---
category: governance
load_order: 1

rules/governance/maintenance.dsl
  enabled: true
  purpose: AGENTS.md maintenance, Obsidian sync, review cycle, conflict resolution

rules/governance/exceptions.dsl
  enabled: true
  purpose: Rule exception categories, approval protocol, no-exception rules, exception tracking

---
category: security
load_order: 2

rules/security.dsl
  enabled: true
  purpose: Secrets handling, input validation, injection prevention, access control, rate limiting, auth hardening, IDOR, audit logging, least privilege, HTTPS, security headers, CORS, error safety, file upload, dependency scanning, supply chain, crypto standards, zero trust, CI/CD, secure defaults

---
category: architecture
load_order: 3

rules/architecture.dsl
  enabled: true
  purpose: Layer separation, API design, SRP, naming conventions, readability limits, abstraction limits, dependency policy, error handling, documentation, configuration layering, logging field standard, startup validation

---
category: testing
load_order: 4

rules/testing.dsl
  enabled: true
  purpose: Production test requirement, TDD preference, framework selection, regression protection, exceptions, test isolation, mocking discipline, coverage thresholds, flaky test protocol, test pyramid, naming, file organization, integration/E2E strategy, assertions, maintenance, async testing

---
category: git
load_order: 5

rules/git.dsl
  enabled: true
  purpose: Branch naming, commit/PR policy, force push protection, secret scanning, merge strategy, commit message format, branching model, bisect, rebase, hooks, .gitignore, signing, PR size, tags, revert, branch cleanup

---
category: migration
load_order: 6

rules/migration.dsl
  enabled: true
  purpose: Migration tools, rollback requirements, production safeguards, naming conventions

---
category: workflow
load_order: 7

rules/workflow/research.dsl
  enabled: true
  purpose: Search-mode, analyze-mode, agent selection, complexity escalation

rules/workflow/communication.dsl
  enabled: true
  purpose: Language mapping, prompt patterns, process transparency, question protocol, error communication, uncertainty handling, contradiction handling, follow-up etiquette, scope creep, context management, large result protocol, handoff protocol

rules/workflow/quality.dsl
  enabled: true
  purpose: Fix strategy, verification, failure escalation, code review checklist, confidence threshold

---
category: languages
load_order: 8

rules/languages/typescript.dsl
  enabled: true
  purpose: Type safety, import order, export rules, naming, type preferences, null/undefined handling, type placement, type inference

rules/languages/go.dsl
  enabled: true
  purpose: Go stack default, preferred libraries (Gin, GORM, Viper, zap), testing, naming, static analysis

rules/languages/java.dsl
  enabled: true
  purpose: Java stack policy, Spring Boot, JPA, QueryDSL, security, naming, validation, testing, code quality, static analysis

rules/languages/rust.dsl
  enabled: true
  purpose: Windows native application conventions, unsafe auditing, panic strategy, error handling, async runtime, security audit, testing, feature flags, dependency management

rules/languages/python.dsl
  enabled: true
  purpose: Python toolchain (uv, ruff, mypy, pytest), project structure, type hints, linting/formatting, testing, dependencies, naming

---
category: platform
load_order: 9

rules/platform/platform_selection.dsl
  enabled: true
  purpose: Target-to-DSL decision router. Maps project type to the correct DSL files.

rules/platform/react.dsl
  enabled: true
  purpose: React stack (Vite, Zustand, Tamagui), performance targets, component design, state management, error handling, API layer patterns, testing patterns, file structure

rules/platform/backend-go.dsl
  enabled: true
  purpose: Go backend with Gin, GORM, authentication (JWT), authorization (casbin), API response envelope, middleware chain, graceful shutdown, request ID propagation, health check depth, DB connection pool

rules/platform/backend-spring.dsl
  enabled: true
  purpose: Spring Boot backend with JPA, Security, Bean Validation, exception handling, transaction conventions, API versioning, health check depth, DB connection pool, testing conventions

rules/platform/windows.dsl
  enabled: true
  purpose: Windows dev environment, package manager, Docker, ports, cross-env

rules/platform/cli.dsl
  enabled: true
  purpose: CLI tool conventions, Go/Python stack choice, output format, exit codes, I/O discipline, error messages, help text, subcommands, config files, verbosity

rules/platform/container.dsl
  enabled: true
  purpose: Docker Compose conventions, multi-stage builds, service dependency ordering, hot-reload, production compose patterns

rules/platform/postgresql.dsl
  enabled: true
  purpose: PostgreSQL version, naming conventions, indexing, connection pooling, data integrity, migration patterns

rules/platform/nginx.dsl
  enabled: true
  purpose: Nginx SPA fallback, API proxy, TLS/SSL, security headers, upload size limits, logging

rules/platform/redis.dsl
  enabled: true
  purpose: Redis connection, key naming, caching pattern, pub/sub, rate limiting, data types

rules/platform/websocket.dsl
  enabled: true
  purpose: WebSocket connection lifecycle, reconnection, message format, heartbeat, channel subscription, error handling

rules/platform/oauth.dsl
  enabled: true
  purpose: OAuth 2.0/OIDC social login, provider configuration, token storage, callback handling, provider-specific rules

rules/platform/mobile.dsl
  enabled: true
  purpose: Capacitor mobile app, Android config, build workflow, permissions, plugins, deep linking, production build

---
category: design
load_order: 10

rules/design/penpot.dsl
  enabled: true
  purpose: Penpot design-first workflow. UI design must be done in Penpot before coding. MCP server integration.

---
category: observability
load_order: 11

rules/observability.dsl
  enabled: true
  purpose: RED metrics, structured logging, OpenTelemetry tracing, alerting rules, health checks, telemetry cost, dashboard conventions

---
category: ci_cd
load_order: 12

rules/ci_cd.dsl
  enabled: true
  purpose: Pipeline stage design, artifact immutability, environment promotion, deployment strategy, rollback procedure, security gates, secret injection, pipeline optimization, branch triggers

---
category: lessons
load_order: 13

rules/lessons/ai_failures.dsl
  enabled: true
  purpose: Known AI failure patterns (signature drift, import hallucination, type escape, context amnesia, over-engineering, premature refactoring, test drift, hallucinated docs, silent fallback, confirmation bias, false confidence, premature optimization, dependency creep, zombie code)
