# OAuth DSL
# Purpose: Social login (OAuth 2.0 / OIDC) conventions for all projects
# gurume_road uses Kakao/Naver/Google/Apple. stock_tales uses Google/GitHub.

rule flow:
  priority=high
  required=Authorization Code Grant with PKCE for all OAuth flows
  required=state parameter with CSRF protection (random string, validated on callback)
  forbidden=Implicit Grant flow (deprecated, less secure)
  note=PKCE is mandatory even for confidential clients as defense-in-depth

rule provider_config:
  priority=medium
  required=store client credentials in environment variables (.env), never in code
  required=provider configuration: client_id, client_secret, authorize_url, token_url, userinfo_url, redirect_url, scope
  required=validate redirect_uri server-side to prevent open redirect attacks
  preferred=keep provider config in a single file (config.go, settings.py) per backend
  see=security.dsl secrets_handling

rule token_storage:
  priority=high
  required=store access/refresh tokens in httpOnly cookies (not localStorage)
  required=set Secure flag on cookies in production
  required=set SameSite=Lax or Strict on cookies
  required=short-lived access tokens (15-60 minutes) with refresh token rotation
  forbidden=storing tokens in localStorage (XSS vulnerable)
  forbidden=passing tokens in URL query parameters

rule callback_endpoint:
  priority=medium
  required=POST /api/auth/{provider}/callback for OAuth redirect
  required=validate state parameter matches session-stored value
  required=exchange authorization code for tokens via server-to-server POST
  required=return JWT or session cookie to client after successful authentication
  note=state validation prevents CSRF attacks on the callback endpoint

rule provider_specific:
  priority=medium
  required=Kakao: scope includes profile_nickname, profile_image, account_email
  required=Naver: scope includes nickname, profile_image, email
  required=Apple: must use form_post response mode, validate identity_token (JWT)
  required=Google: scope includes profile, email; validate id_token (JWT)
  required=GitHub: scope includes read:user, user:email
  note=Apple requires the private key (p8 file) and team/key IDs for client secret generation

rule oauth_error_handling:
  priority=high
  required=handle OAuth error responses (access_denied, invalid_scope, etc.)
  required=redirect to login page with error message on failure
  required=log provider errors for debugging (without leaking tokens)
  forbidden=exposing provider error details directly to the user (security risk)
