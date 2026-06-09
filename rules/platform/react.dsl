# React Platform DSL
# Purpose: React-specific stack, performance targets, component conventions, state management,
#          error handling, API layer, testing patterns, file structure

rule stack:
  priority=medium
  required=TypeScript
  required=React
  required=Vite (build tool)
  required=Zustand (state management)
  required=React Router (routing)
  required=Axios (HTTP client)
  required=TanStack Query (server state / data fetching)
  required=Vitest (testing)
  preferred=Tamagui (UI framework)
  preferred=React Hook Form (forms)
  preferred=date-fns (date manipulation)

rule performance:
  priority=medium
  target=bundle size <= 200KB gzipped
  target=TTI <= 3.5 seconds on 3G connection
  required=unsubscribe from subscriptions on component unmount
  required=clean up resources (event listeners, intervals, observers)
  preferred=code splitting for large routes

rule component_design:
  priority=low
  preferred=custom hooks over HOCs for logic reuse
  preferred=colocate components by feature/domain
  preferred=one primary export per file

rule accessibility:
  priority=medium
  trigger=any web frontend project or public-facing UI
  trigger=project reaches production/public release
  required=public UI must meet WCAG 2.1 AA
  required=semantic HTML, aria-* attributes, keyboard navigation
  required=contrast ratio >= 4.5:1
  exception=internal/admin-only UIs, prototypes, development-phase projects

rule state_management:
  priority=medium
  required=use local state (useState) for component-private UI state (toggle, form input, dropdown open)
  required=use Zustand for shared application state (auth, theme, notifications, global UI)
  required=keep server-fetched data in custom hooks with Axios, not in Zustand store
  preferred=colocate Zustand store slices by domain, not by type (authStore, themeStore, not uiStore)
  note=duplicating server state in Zustand causes stale data; fetch and cache at the hook level

rule component_error_handling:
  priority=medium
  required=wrap route-level components in ErrorBoundary with fallback UI
  required=handle async errors in data-fetching components with error state and retry mechanism
  preferred=use ErrorBoundary for rendering errors, try-catch for event handlers
  review=check every data-fetching component for loading, error, and empty states
  note=unhandled errors crash the entire React tree; error boundaries limit blast radius

rule api_layer_patterns:
  priority=medium
  required=create Axios instance with baseURL, timeout, and default headers
  required=use Axios interceptors for: auth token injection, token refresh on 401, centralized error handling
  required=create custom hooks per API resource (useUsers, usePosts) wrapping Axios calls
  preferred=define request and response types at the API layer, not inline in components
  note=centralized API layer prevents scattered auth logic and inconsistent error handling

rule testing_patterns:
  priority=medium
  required=use React Testing Library for component tests (not Enzyme)
  required=test behavior, not implementation (query by role or text, not test IDs unless necessary)
  required=cover: rendering, user interaction, loading state, error state, empty state
  preferred=co-locate test files next to the component they test (*.test.tsx)
  note=over-mocking leads to brittle tests; prefer integration-style tests with real hooks

rule file_structure:
  priority=medium
  required=organize by domain or feature, not by type: features/{feature}/, pages/, components/shared/, hooks/, utils/
  required=each feature folder contains its own components, hooks, types, and tests
  preferred=shared components in components/shared/, feature-specific in features/{feature}/components/
  forbidden=flat components/ folder with hundreds of unrelated files
  see=architecture.dsl  # naming_conventions for file naming rules

rule performance_patterns:
  priority=medium
  required=use React.memo on components that render often with same props (lists, cards, table rows)
  required=use useMemo for expensive computations, useCallback for stable callback references
  preferred=virtualize long lists (react-window or equivalent for > 100 items)
  preferred=lazy load images with loading="lazy" or IntersectionObserver
  review=check for unnecessary re-renders during code review
  note=premature optimization is wasteful; profile before adding memo or useMemo
