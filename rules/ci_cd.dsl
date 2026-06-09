# CI/CD DSL
# Purpose: Pipeline design, deployment strategy, environment promotion, artifact management, rollback procedures
# NOTE: All CI/CD rules apply only to projects with CI/CD pipelines.
#       Skip for prototypes, one-off scripts, and early-development projects.

rule pipeline_stages:
  priority=medium
  required=pipeline stages ordered: lint → unit test → build → security scan → integration test → deploy
  required=parallelize independent stages (lint + unit test run simultaneously)
  required=fail fast: cheapest checks first (lint before integration test)
  see=languages/go.dsl static_analysis
  see=languages/java.dsl static_analysis
  see=security.dsl ci_cd_security

rule artifact_immutability:
  priority=high
  required=build artifact once, promote identical artifact through all environments
  forbidden=rebuilding artifact per environment (staging != production)
  required=tag artifacts with git SHA + build timestamp
  note=immutable artifacts guarantee what is tested in staging equals what runs in production

rule environment_promotion:
  priority=medium
  required=promotion path: dev → staging → canary → production
  required=each promotion gate requires passing all previous stage checks
  required=staging must mirror production configuration (CPU, memory, replicas, env vars)
  allowed=skip canary for low-risk deployments with user approval

rule deployment_strategy:
  priority=high
  approval=user must approve production deployment before execution
  preferred=blue-green or canary deployment for production
  forbidden=direct in-place replacement without documented rollback plan
  forbidden=deploying to production without explicit user approval
  required=health check verification after deployment before traffic cutover
  required=monitor error rate and latency for 5 minutes post-deployment
  note=gradual rollout limits blast radius

rule rollback_procedure:
  priority=high
  required=every deployment must have a documented rollback plan
  required=rollback deploys the previous artifact (never rebuild from source)
  required=automated rollback triggers on health check failure within 5 minutes
  required=rollback plan tested at least once per release cycle
  forbidden=rolling back by redeploying the current commit (use the previous artifact)

rule security_gates:
  priority=high
  required=SAST scan before build, container scan after build, IaC scan before deploy
  required=CI fails on critical or high severity vulnerabilities
  see=security.dsl ci_cd_security

rule secret_injection:
  priority=high
  required=secrets injected at deploy time via CI/CD secrets manager (GitHub Actions secrets, Vault, AWS Secrets Manager)
  forbidden=hardcoded secrets in pipeline YAML, scripts, or configuration files
  required=short-lived credentials with automatic rotation
  required=audit secret access in CI/CD logs

rule pipeline_optimization:
  priority=low
  preferred=restore cached dependencies before install to reduce pipeline time
  preferred=git clone --depth=1 for CI (shallow clone reduces fetch time)
  preferred=test impact analysis: run only tests for changed modules
  note=optimizations reduce feedback loop without compromising safety

rule branch_triggers:
  priority=medium
  required=feat/* branches: build + test only (fast feedback)
  required=main branch: build + test + security scan + staging deploy
  required=release/* branches: full pipeline + production deploy
  required=hotfix/* branches: full pipeline + expedited production deploy
