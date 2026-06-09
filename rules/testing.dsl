# Testing DSL
# Purpose: Test requirements, framework selection, TDD preference, exception rules,
#          test isolation, mocking discipline, coverage thresholds, flaky test protocol,
#          test pyramid, test naming, file organization, integration/e2e strategy,
#          assertions, maintenance, async testing

rule production_testing:
  priority=high
  see=governance/exceptions.dsl  # exception categories and approval protocol
  required=production code includes tests
  exception=prototype, one-off script, configuration-only code
  exception=active development phase (pre-release) — tests required only for critical paths
  trigger=project reaches production readiness
  action=if prototype/development: skip, but document as tech debt
  review=verify test coverage for new business logic

rule tdd_preference:
  priority=low
  preferred=TDD cycle: RED (write failing test) -> GREEN (make pass) -> REFACTOR
  preferred=write tests before implementation for business logic

rule testing_focus:
  priority=low
  preferred=test business logic, API endpoints, and utility functions
  skip=prototype code, one-off scripts, configuration files

rule framework_selection:
  priority=medium
  required=TypeScript: Vitest
  required=Go: testing package + testify
  required=Python: pytest
  required=Java: JUnit 5 + Mockito

rule regression_protection:
  priority=high
  required=verify existing tests still pass after changes
  forbidden=deleting failing tests to "make them pass"
  action=if tests fail: fix the code, not the tests

rule test_isolation:
  priority=high
  required=each test sets up and tears down its own state
  forbidden=shared mutable state between tests
  forbidden=relying on test execution order

rule mocking_discipline:
  priority=high
  required=mock at system boundaries (I/O, network, time, external APIs)
  forbidden=mocking internals of the unit under test
  preferred=fakes over mocks for in-memory implementations

rule coverage_thresholds:
  priority=medium
  required=minimum 80% line coverage for production code at release
  allowed=development phase: no minimum, but critical paths (auth, payments, data loss) should be covered
  required=100% for critical paths (auth, payments, data loss) in production
  required=CI failure if coverage below threshold at release time
  trigger=project reaching production release

rule flaky_test_protocol:
  priority=high
  required=flaky tests quarantined (excluded from CI) with issue tracking
  required=48-hour fix deadline; delete if not fixed
  action=use rerun-failed or --flaky detection in CI
  see=workflow/quality.dsl verification
  see=lessons/ai_failures.dsl test_drift

rule test_pyramid:
  priority=medium
  preferred=~70% unit, ~20% integration/contract, ~10% e2e
  action=if ratio is inverted, adjust test strategy

rule test_naming:
  priority=medium
  required=format: describe('Feature') / it('returns X when Y')
  required=test names read as English sentences describing expected behavior

rule test_file_organization:
  priority=medium
  required=co-locate with source as *.test.ts / *_test.go / test_*.py
  allowed=integration tests go in tests/integration/ directory

rule performance_testing:
  priority=low
  trigger=project with latency SLAs or high-throughput requirements
  preferred=k6 for load testing (Go-based, scriptable)
  preferred=include at least one load test per critical endpoint before production launch
  note=performance testing prevents regression in latency-sensitive systems

rule integration_test_strategy:
  priority=medium
  trigger=project has database or external service dependencies
  required=use real databases in test containers, not in-memory fakes
  required=clean data between test runs
  preferred=factory functions for test data
  skip=prototypes and one-off scripts

rule e2e_test_strategy:
  priority=medium
  required=e2e for critical user journeys only (login, purchase, export)
  required=run in CI on merge to main or nightly, not every commit
  preferred=Playwright for E2E testing (see available skill)
  action=tag flaky e2e tests for automatic quarantine
  see=ci_cd.dsl pipeline_stages  # E2E stage placement in pipeline

rule test_assertions:
  priority=medium
  required=use descriptive matchers (toEqual, toContain) over boolean
  forbidden=expect(true).toBe(true) patterns

rule test_maintenance:
  priority=medium
  action=if behavior intentionally changed: update test
  action=if test covers removed functionality: delete it
  forbidden=commenting out tests or leaving skipped tests without issue reference

rule async_testing:
  priority=medium
  required=always await promises in tests
  required=set explicit timeouts, use fake timers for time-dependent code
  forbidden=raw setTimeout in tests
