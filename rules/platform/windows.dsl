# Windows Platform DSL
# Purpose: Windows-specific environment conventions, dev setup

rule package_manager:
  priority=low
  preferred=winget (Windows Package Manager)
  allowed=Chocolatey if team-consistent

rule local_tooling:
  priority=medium
  required=use npx or npm run for local tool execution
  forbidden=./node_modules/.bin/ direct invocation

rule environment_variables:
  priority=medium
  required=use cross-env for setting environment variables
  forbidden=NODE_ENV=production (no cross-platform)
  forbidden=set NODE_ENV=production (PowerShell incompatible)

rule services:
  priority=medium
  required=Docker Compose v2 for local services
  required=hot-reload enabled for development
  required=.env.local for local overrides

rule ports:
  priority=low
  default=Frontend: :5173 (Vite default)
  default=Backend: :8080
  default=API docs: :8080/docs

rule setup:
  priority=medium
  target=clone -> docker compose up + seed -> ready in under 5 minutes
