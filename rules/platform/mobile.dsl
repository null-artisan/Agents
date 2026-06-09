# Mobile (Capacitor) DSL
# Purpose: Capacitor-based mobile app conventions (Android)
# gurume_road uses Capacitor 8 for Android native deployment.

rule framework:
  priority=medium
  required=Capacitor 8 for mobile deployment (matches gurume_road client)
  required=capacitor.config.ts at project root
  required=webDir points to Vite build output (dist)
  allowed=latest stable Capacitor version for new projects

rule android_config:
  priority=medium
  required=appId in reverse-domain format (com.gurumeroad.app)
  required=allowMixedContent=true for development (HTTP API access)
  required=splashScreen configuration with backgroundColor
  preferred=set androidScheme to https for production
  note=HTTP cleartext is needed for local development but should be disabled in production

rule build_workflow:
  priority=medium
  required=build web app first: vite build
  required=sync to native project: npx cap copy (or cap sync)
  required=open native IDE: npx cap open android
  preferred=script: "build:mobile": "vite build && npx cap copy"
  note=Capacitor syncs web assets to native project; rebuild web before every sync

rule permissions:
  priority=medium
  required=declare Android permissions in android/app/src/main/AndroidManifest.xml
  required=INTERNET permission for API access
  required=only request permissions the app actually uses
  forbidden=overly broad permission declarations

rule plugins:
  priority=low
  preferred=@capacitor/plugins for native functionality (camera, geolocation, etc.)
  required=install plugin via npm before using
  required=run npx cap sync after adding plugins
  note=Capacitor plugins provide native API access through JavaScript interfaces

rule deep_linking:
  priority=medium
  required=configure intent-filters for custom URL schemes
  required=handle deep links in the web app via the Capacitor App plugin
  preferred=use universal links (iOS) / app links (Android) over custom schemes
  note=deep linking is required for OAuth redirects in mobile apps

rule production_build:
  priority=medium
  required=disable cleartext HTTP in production release builds
  required=sign Android APK/AAB with production keystore
  required=test on physical device before release
  preferred=use Android App Bundle (AAB) for Play Store distribution
