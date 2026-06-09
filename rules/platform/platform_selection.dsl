# Platform Selection DSL
# Purpose: Decision router — maps project target type to the correct DSL files.
# Does NOT duplicate stack details. See individual DSL files for specifics.

rule web_app:
  target=Web application frontend
  priority=medium
  see=languages/typescript.dsl
  see=platform/react.dsl
  see=design/penpot.dsl  # Design-First: UI must be designed in Penpot before coding
  see=security.dsl  # security headers, CORS

rule web_backend:
  target=Web backend
  priority=medium
  see=platform/backend-go.dsl
  see=languages/go.dsl
  see=ci_cd.dsl
  see=observability.dsl
  see=platform/postgresql.dsl
  see=platform/container.dsl
  see=platform/nginx.dsl
  see=security.dsl
  exception=required library exclusive to Python -> see=languages/python.dsl

rule java_backend:
  target=Web backend (Java)
  priority=medium
  approval=Java only when more appropriate than Go; user must confirm
  see=languages/java.dsl
  see=platform/backend-spring.dsl
  see=ci_cd.dsl
  see=observability.dsl

rule windows_app:
  target=Windows native application
  priority=medium
  see=languages/rust.dsl

rule cli_tool:
  target=Command-line tool / script
  priority=medium
  preferred=languages/go.dsl
  allowed=Python when Go is overkill -> see=languages/python.dsl

rule ui_design:
  target=UI design (mockups, wireframes, screen layouts)
  priority=high
  required=Penpot (design.penpot.app) + local MCP server (HTTP, not stdio)
  required=design before code: UI design MUST be completed in Penpot before implementation
  required=design complete checklist verified before UI code (see design/penpot.dsl design_complete_checklist)
  trigger=user requests UI design, mockup, wireframe, screen layout, or any visual UI task
  trigger=project requires UI component, page layout, or visual styling
  action=load design/penpot.dsl and follow its rules in full
  action=verify Penpot MCP server is accessible at http://localhost:4401/mcp
  action=prompt user to connect Penpot plugin if not connected
  action=if MCP server unavailable: fallback to explicit user approval (P1)
  forbidden=bypassing Penpot for UI design work
  forbidden=guessing design tokens without Penpot (even with fallback approval, ask user directly)
  note=Penpot MCP uses HTTP transport. Not compatible with opencode config.json stdio MCP.

# Production testing requirement is defined in rules/testing.dsl directly
