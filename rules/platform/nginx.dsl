# Nginx DSL
# Purpose: Nginx reverse proxy and static file serving conventions
# Both gurume_road and stock_tales use Nginx to serve SPA frontends and proxy API requests.

rule spa_configuration:
  priority=medium
  required=try_files $uri $uri/ /index.html for SPA fallback routing
  required=set Cache-Control headers for static assets (immutable for hashed files)
  required=disable ETag for index.html to prevent stale SPA deployments
  forbidden=allowing directory listing (autoindex off)

rule api_proxy:
  priority=medium
  required=proxy_pass to backend service for /api/* routes
  required=proxy_set_header Host, X-Real-IP, X-Forwarded-For, X-Forwarded-Proto
  required=proxy_http_version 1.1 for WebSocket support (upgrade header)
  required=proxy_read_timeout >= 60s for long-running API requests
  note=WebSocket requires Connection and Upgrade headers to be forwarded

rule ssl_tls:
  priority=high
  see=security.dsl crypto_standards
  required=TLS 1.2 or higher only (TLS 1.0 and 1.1 forbidden)
  required=redirect HTTP to HTTPS (return 301)
  required=use strong cipher suites (intermediate profile from Mozilla SSL Config)
  forbidden=self-signed certificates in production

rule security_headers:
  priority=high
  see=security.dsl security_headers
  required=add_header X-Frame-Options DENY
  required=add_header X-Content-Type-Options nosniff
  required=add_header X-XSS-Protection "0" (deprecated but still present)
  required=add_header Referrer-Policy strict-origin-when-cross-origin

rule file_upload_size:
  priority=medium
  required=client_max_body_size must match backend upload limit
  required=set explicit limit (default 1M is too small for image uploads)
  note=both docker-compose and nginx need aligned upload size limits

rule logging:
  priority=medium
  required=log format includes: $remote_addr, $request, $status, $body_bytes_sent, $upstream_addr, $upstream_response_time
  preferred=use JSON log format for log aggregation
  forbidden=logging request bodies containing sensitive data
