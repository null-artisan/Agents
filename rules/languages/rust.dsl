# Rust DSL
# Purpose: Windows application conventions, Rust-specific rules

rule target:
  priority=medium
  required=Rust for Windows native applications (Win32 API, GUI, system tools)
  allowed=alternative to Go/Python when native performance or system-level access required

rule naming:
  priority=medium
  required=snake_case for variables, functions, modules, and file names
  required=PascalCase for types, traits, enums, and structs
  preferred=short, descriptive module names (single word preferred)
  see=architecture.dsl naming_conventions

rule conventions:
  priority=low
  preferred=follow standard Rust edition conventions
  preferred=use cargo workspace for multi-crate projects
  preferred=clippy for linting

rule unsafe_audit:
  priority=high
  required=every unsafe block has // SAFETY: comment explaining invariants
  required=unsafe functions require # Safety doc section
  preferred=prefer safe abstractions over raw unsafe

rule panic_strategy:
  priority=high
  required=library code returns Result — never panic to caller
  required=use .expect("descriptive message") over bare .unwrap()
  forbidden=bare .unwrap() in production code

rule error_handling:
  priority=medium
  preferred=binaries: anyhow for error propagation with context
  preferred=libraries: thiserror for typed error enums
  forbidden=implementing std::error::Error manually

rule async_runtime:
  priority=medium
  required=tokio as primary async runtime
  required=single runtime per binary (never mix runtimes)
  preferred=library crates runtime-agnostic or feature-gated

rule security_audit:
  priority=high
  required=cargo audit runs in CI on every PR
  required=cargo deny for license + advisory checks
  required=deny.toml in repo root

rule testing:
  priority=medium
  preferred=proptest for property-based testing
  preferred=test-case for table-driven tests
  required=integration tests go in tests/ not src/

rule feature_flags:
  priority=medium
  required=feature flags are additive (semver-friendly)
  required=features documented with purpose
  preferred=feature over cfg(target_os) for platform-specific code

rule dependency_management:
  priority=medium
  required=minimize dependencies, audit each addition
  required=use workspace.dependencies to unify versions
  required=run cargo outdated regularly
