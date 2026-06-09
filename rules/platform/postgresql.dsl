# PostgreSQL DSL
# Purpose: PostgreSQL conventions used across all projects under this governance system
# Every project uses PostgreSQL 16 as the primary database.

rule version:
  priority=medium
  required=PostgreSQL 16 for all new projects (matches docker-compose.yml)
  allowed=existing projects may use older versions, plan upgrade path

rule naming_conventions:
  priority=medium
  required=snake_case for all database identifiers (tables, columns, indexes)
  required=table names are plural (users, posts, comments)
  required=primary key column named id (UUID or BIGSERIAL)
  required=foreign key columns named {singular_table}_id (user_id, post_id)
  required=created_at and updated_at timestamps on all tables
  forbidden=reserved words as column names without quoting

rule migration:
  priority=medium
  see=migration.dsl  # migration_tools rule covers tool-specific requirements
  required=all schema changes go through migration system
  required=each migration is reversible (up + down)
  forbidden=manual ALTER TABLE in production

rule indexing:
  priority=medium
  required=index all foreign key columns
  required=index columns used in WHERE, ORDER BY, and JOIN conditions
  preferred=B-tree for equality/range queries, GIN for full-text search
  review=check query plans for missing indexes during code review

rule connection_pooling:
  priority=medium
  required=configure connection pool limits (max 25 connections per app instance)
  required=set statement timeout (30s default) to prevent runaway queries
  preferred=use PgBouncer in transaction mode for high-concurrency services
  note=connection pool exhaustion is a common production failure mode

rule data_integrity:
  priority=high
  required=define NOT NULL, UNIQUE, CHECK constraints at the database level
  required=use foreign key constraints with ON DELETE CASCADE or RESTRICT
  forbidden=relying solely on application-level validation for data integrity
