# Redis DSL
# Purpose: Redis caching, pub/sub, and session store conventions
# Used in stock_tales for price caching and pub/sub real-time updates.

rule connection:
  priority=medium
  required=Redis 7+ (matches docker-compose.yml redis:7-alpine)
  required=connection string via environment variable (REDIS_URL)
  required=connection pool with max connections limit
  preferred=configure retry and timeout settings
  forbidden=hard-coding Redis host/port in application code

rule key_naming:
  priority=medium
  required=key format: {service}:{domain}:{id} (e.g., stock_tales:price:AAPL)
  required=set TTL on all cache keys
  required=use consistent separator (colon)
  forbidden=keys without TTL unless deliberately persistent
  note=TTL prevents stale data and memory exhaustion

rule caching_pattern:
  priority=medium
  required=cache-aside pattern: read from cache -> miss -> load from DB -> write to cache
  required=cache invalidation on write operations (delete or update cache entry)
  preferred=use Redis SET with EX/PX for atomic set+expire
  review=check for missing cache invalidation during code review

rule pub_sub:
  priority=medium
  trigger=real-time data broadcasting needed
  required=use Redis pub/sub for one-to-many message broadcasting
  required=structured message format: { channel, event, data, timestamp }
  required=handle subscriber reconnection with resubscription
  preferred=separate connection for pub/sub (non-blocking)
  note=pub/sub is fire-and-forget; no message persistence if no subscriber

rule rate_limiting:
  priority=medium
  see=security.dsl rate_limiting
  preferred=Redis-backed sliding window or token bucket for distributed rate limiting
  allowed=in-memory rate limiting for single-instance services
  note=Redis enables consistent rate limits across multiple app instances

rule data_types:
  priority=medium
  preferred=STRING for simple values, HASH for objects, LIST for queues, SET for uniqueness, SORTED_SET for rankings
  forbidden=using Redis as primary database (it is a cache/store, not a replacement for PostgreSQL)
