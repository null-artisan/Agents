# Security DSL
# Purpose: Comprehensive security — secrets handling, access control, input/injection/IDOR validation,
#          HTTPS, headers, CORS, auth hardening, rate limiting, audit logging, least privilege,
#          file upload safety, dependency supply chain, crypto standards, zero trust, CI/CD security

rule secrets_handling:
  priority=high
  forbidden=secrets in plaintext, .env files committed, secrets in logs, secrets in URLs, secrets in HTTP headers
  required=use process.env or secret manager
  allowed=.env.example only in repository (no real values)
  trigger=any file write containing credential patterns
  verify=scan for secret patterns before commit

rule input_validation:
  priority=high
  required=validate and sanitize all external input
  forbidden=trusting unsanitized user input
  action=apply allowlist-based validation

rule access_control:
  priority=high
  required=allowlist-based access control
  forbidden=denylist-only access control

rule vulnerability_reporting:
  priority=high
  trigger=vulnerability found at any stage (design, code review, testing)
  action=raise immediately, stop current task
  required=document vulnerability before proceeding

rule logging_security:
  priority=medium
  forbidden=sensitive data in logs (passwords, tokens, PII)
  required=structured log levels: debug, info, error
  action=on error: log what failed, where, relevant data (no secrets)

rule accessibility:
  priority=medium
  see=platform/react.dsl  # accessibility rule in react.dsl is the single source of truth

rule database_safety:
  priority=high
  see=migration.dsl production_safeguards
  forbidden=DROP or TRUNCATE in production
  required=user approval before any DB-affecting command
  note="Just test data" is not an exception

rule https_enforcement:
  priority=high
  required=all production traffic must use HTTPS
  required=redirect HTTP to HTTPS at infrastructure or app level
  required=all Set-Cookie responses must include Secure flag
  forbidden=mixed content (HTTPS page loading HTTP resources)
  review=check for HTTP URLs and missing Secure flag on cookies

rule security_headers:
  priority=high
  required=Content-Security-Policy header restricting script and style sources
  required=Strict-Transport-Security header (max-age >= 31536000, includeSubDomains)
  required=X-Frame-Options: DENY or SAMEORIGIN
  required=X-Content-Type-Options: nosniff
  review=check for missing security headers during code review

rule error_safety:
  priority=high
  forbidden=leaking stack traces, internal paths, DB details, or config values to client in production
  required=return generic error messages to client; log full details server-side
  review=verify error response bodies during code review

rule cors_config:
  priority=medium
  forbidden=Access-Control-Allow-Origin: * in production
  required=use explicit origin allowlist for CORS
  required=validate Origin header against allowlist
  exception=public API endpoints with no authentication requirement

rule dependency_vuln_scan:
  priority=high
  required=run vulnerability scan in CI (npm audit, go vulncheck, trivy, or equivalent)
  required=fail CI build on critical or high severity vulnerabilities
  required=keep dependencies updated (Dependabot, Renovate, or scheduled review)
  action=when CVE found: assess exploitability before upgrading blindly
  note=dependency freshness prevents exploitation of known CVEs

rule injection_prevention:
  priority=high
  required=use parameterized queries or ORM for all database access (SQL injection prevention)
  required=apply context-aware output encoding for user-controlled data in HTML/JS (XSS prevention)
  forbidden=constructing shell commands with unsanitized user input (command injection prevention)
  allowed=prepared statements, query builders, ORMs — raw string concatenation prohibited
  review=scan for string interpolation in SQL queries and HTML templates during code review

rule rate_limiting:
  priority=high
  required=apply rate limiting to authentication endpoints (login, registration, password reset)
  required=return 429 Too Many Requests when limit exceeded
  preferred=sliding window or token bucket algorithm
  allowed=configurable limits per endpoint and per user/IP
  note=rate limiting is the primary defense against brute force and credential stuffing

rule auth_hardening:
  priority=high
  required=hash passwords with bcrypt (cost >= 10) or argon2
  required=lock account after N consecutive failed login attempts (N <= 10)
  preferred=support MFA for sensitive operations (admin panel, data export, permission changes)
  preferred=enforce password complexity (minimum 8 characters, mixed case, digits)
  note=authentication libraries (JWT, Spring Security) are defined in platform DSLs; this covers universal hardening

rule idor_protection:
  priority=high
  required=verify resource ownership before returning or modifying data
  required=scope database queries to the authenticated user (WHERE user_id = current_user)
  forbidden=trusting user-supplied resource IDs without ownership verification
  review=check every endpoint with a resource ID parameter verifies access rights

rule audit_logging_security:
  priority=medium
  required=log all authentication events (login success, login failure, logout, token refresh)
  required=log authorization changes (role assignment, permission grant or revoke)
  required=log sensitive data operations (delete, export, bulk update)
  forbidden=including the secret itself (password, token, session) in audit log entries
  note=audit logs are for security forensics; they must be immutable and timestamped

rule least_privilege:
  priority=medium
  required=database users must have minimum required permissions (separate read-only and read-write)
  required=service accounts must be scoped to specific resources and actions
  required=API keys must have minimum required scope (not full access)
  forbidden=using a single privileged account for all operations
  review=audit service account permissions during code review

rule file_upload_safety:
  priority=medium
  required=validate file type against an allowlist (not denylist)
  required=enforce maximum file size limit
  required=store uploaded files outside the webroot or in a dedicated asset service
  required=randomize stored file names (no user-supplied file names on disk)
  forbidden=allowing executable file types (.exe, .sh, .jar, .php, etc.)
  review=check file upload handling during code review

rule supply_chain_depth:
  priority=medium
  required=pin dependency versions with integrity verification (lock files + integrity hashes)
  required=generate SBOM for production releases (CycloneDX or SPDX format)
  preferred=signed commits and signed release artifacts
  action=when adding new dependency: evaluate maintenance status, release frequency, CVE history
  note=supply chain attacks target dependencies; integrity verification prevents tampered packages

rule crypto_standards:
  priority=high
  required=use TLS 1.2 or higher for all network communication (TLS 1.0 and 1.1 forbidden)
  required=use modern AEAD ciphers: AES-GCM, ChaCha20-Poly1305 (CBC mode ciphers forbidden)
  forbidden=using deprecated cryptographic algorithms (MD5, SHA-1, RC4, 3DES, RSA < 2048 bits)
  required=store cryptographic keys in a dedicated secrets manager (not in config files or code)
  review=audit cipher suites and key storage during code review

rule zero_trust_internal:
  priority=medium
  required=authenticate and authorize every request, including internal service-to-service calls
  required=use mTLS or equivalent for service-to-service authentication
  forbidden=trusting requests based on network origin (internal IP, localhost, VPC alone)
  review=verify that internal endpoints are not exempt from authentication
  note=assume breach: the internal network is not inherently safe

rule ci_cd_security:
  priority=high
  required=run SAST (static analysis) in CI pipeline
  required=scan container images for vulnerabilities before deployment
  required=scan infrastructure-as-code for security misconfigurations
  preferred=integrate DAST (dynamic analysis) for deployed staging environments
  action=fail CI build on critical or high severity findings
  note=CI/CD is the enforcement point for most security rules; build must fail on violations

rule secure_defaults:
  priority=high
  required=keep framework security defaults enabled (CSRF protection, CSP middleware, etc.)
  forbidden=disabling security features for development convenience
  exception=explicitly documented risk acceptance with user approval
  review=audit configuration for disabled security features during code review
  note=defense in depth: multiple layers should each be enabled independently
