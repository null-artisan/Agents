# Migration DSL
# Purpose: Database migration tools, rollback requirements, production safeguards, naming conventions

rule migration_tools:
  priority=medium
  required=Go: golang-migrate
  required=TypeScript/Node: Prisma or Knex
  required=Python: Alembic
  required=Java: Flyway
  forbidden=raw SQL scripts without migration tooling

rule rollback_requirement:
  priority=high
  required=all migrations must be reversible (up AND down)
  required=each migration must have a corresponding rollback

rule production_safeguards:
  priority=high
  required=data-loss operations need explicit user approval
  required=test migration against production copy before applying
  forbidden=applying data-loss migrations directly to production
  trigger=project has active user data or is in production
  skip=early development with no production data (schema can be rebuilt)

rule migration_naming:
  priority=medium
  required=prefix migration files with timestamp (YYYYMMDDHHMMSS) for ordering
  required=include semantic description in the migration name
  note=example: 20260528120000_create_users_table.sql
  forbidden=using sequential numbers (1.sql, 2.sql) which cause conflicts in team environments
