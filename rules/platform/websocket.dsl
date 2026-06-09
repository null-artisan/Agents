# WebSocket DSL
# Purpose: Real-time communication via WebSocket connections
# Used in stock_tales for streaming real-time stock price updates.

rule connection_lifecycle:
  priority=medium
  required=establish WebSocket connection after client authentication
  required=handle connection open, message, error, and close events
  required=clean up connection resources on close (remove from subscription registry)
  preferred=use a connection manager to track active connections
  forbidden=leaking unclosed WebSocket connections (memory leak)

rule reconnection:
  priority=medium
  required=implement exponential backoff for reconnection (1s, 2s, 4s, 8s, max 30s)
  required=limit reconnection attempts (max 10) before giving up
  required=resubscribe to channels after reconnection
  preferred=jitter on backoff to prevent thundering herd
  note=without reconnection, temporary network issues cause permanent disconnection

rule message_format:
  priority=medium
  required=JSON message format: { type, payload, timestamp }
  required=type field for message routing (price_update, trade, notification)
  required=timestamp in ISO 8601 format
  forbidden=unstructured plain text messages

rule heartbeat:
  priority=medium
  required=server sends ping every 30 seconds
  required=client responds with pong
  required=close connection if no pong received within 10 seconds (dead connection cleanup)
  note=heartbeat detects zombie connections caused by network drops without FIN packet

rule channel_subscription:
  priority=medium
  required=client subscribes to channels via subscription message
  required=server validates subscription authorization before adding
  required=clean up subscriptions when connection closes
  preferred=one connection per client with multi-channel subscription
  note=authorization check prevents unauthorized data access

rule ws_error_handling:
  priority=high
  required=send error message to client with error code and description
  required=log all WebSocket errors server-side with connection ID
  required=close connection on protocol violation (invalid message format, unauthorized subscription)
  forbidden=silently dropping malformed messages without logging

rule backend_pattern:
  priority=medium
  trigger=Python (FastAPI) backend
  preferred=FastAPI WebSocket endpoint with dependency injection for auth
  trigger=Go backend
  preferred=Gin WebSocket via gorilla/websocket or nhooyr.io/websocket
  note=WebSocket upgrade must happen before authentication middleware in the middleware chain
