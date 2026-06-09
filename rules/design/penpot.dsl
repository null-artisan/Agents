# Penpot DSL
# Purpose: Design-first workflow using Penpot as the designated UI design tool.
# Penpot uses HTTP-based MCP (not stdio) — requires plugin in browser + local MCP server.
# All UI design work MUST be done in Penpot before any code is written.
# {penpot_mcp_port} = port determined by Docker configuration (default: 4401)

rule design_first_workflow:
  priority=high
  trigger=any project requiring UI, mockup, wireframe, screen layout, or visual design
  action=1. Design FIRST in Penpot (design.penpot.app) — all screens, components, tokens
  action=2. Run Penpot MCP server via Docker (official Docker image). Do NOT install Penpot MCP directly.
  action=3. In Penpot browser: Plugins → Load from URL → http://localhost:4400/manifest.json
  action=4. In Penpot plugin: click "Connect to MCP server" (connects via ws://localhost:4402)
  action=5. Once connected, AI extracts design context via MCP HTTP endpoint
  action=6. Write code based on design specifications
  verified=Penpot MCP server responds at http://localhost:{penpot_mcp_port}/mcp
  verified=Penpot plugin shows "Connected" status
  forbidden=writing UI code before Penpot design is complete and verified
  forbidden=guessing colors, spacing, layouts without referencing Penpot

rule mcp_availability:
  priority=high
  trigger=user requests UI design task or code generation from design
  action=verify Penpot MCP server: GET http://localhost:{penpot_mcp_port}/mcp returns 200 or MCP response
  action=if MCP not responding: tell user "Penpot MCP server is not running. Please start via Docker (official image)."
  action=after server starts: ask user to load plugin in Penpot and connect
  action=if user confirms server cannot be started:
    action=request explicit P1 approval: "Proceed without Penpot? Colors/spacing will need manual input."
    action=if approved: ask user directly for each design token — no guessing
  action=DO NOT proceed with UI code generation until MCP responds OR user explicitly approved fallback
  note=Penpot MCP is HTTP-based, NOT stdio. It cannot be managed via opencode config.json.

rule design_extraction:
  priority=high
  trigger=AI needs to read design context before generating code
  action=POST http://localhost:{penpot_mcp_port}/mcp with design extraction request
  action=extract: layout structure, color tokens, typography, spacing, component hierarchy
  action=OUTPUT FORMAT:
    colors: { "--color-primary": "...", "--color-bg": "..." }
    typography: { fontFamily: { heading, body }, fontSize: { sm, md, lg, xl, ... }, fontWeight: { ... } }
    spacing: { unit: 4, scale: [4, 8, 12, 16, 20, 24, 32, 40, 48, 64] }
    components: [{ name, variants: [...], states: [...], children: [...] }]
    layout: { screens: [{ name, width, height, elements: [...] }] }
  action=document tokens in code-compatible format (CSS vars, Tailwind config, theme object)
  note=MCP endpoint uses Streamable HTTP transport at http://localhost:{penpot_mcp_port}/mcp

rule penpot_servers:
  priority=medium
  note=Penpot MCP server MUST be run via Docker (official Docker image). Do NOT install or run directly.
  note=Two servers run inside the Docker container for Penpot MCP to work
  note=server_info: MCP server at http://localhost:{penpot_mcp_port}/mcp (ws://localhost:4402); Plugin server at http://localhost:4400
  action=Start via: docker run [official-penpot-mcp-image]
  action=Stop via: docker stop [container-name]

rule design_tokens:
  priority=high
  required=extract all design tokens from Penpot before coding
  fields=colors, typography (font, size, weight), spacing (4px grid), border-radius, shadows
  action=map Penpot tokens to CSS variables / Tailwind config / theme object
  note=Penpot design tokens are the single source of truth

rule component_mapping:
  priority=medium
  required=read Penpot component structure before building code components
  action=map Penpot components to code components one-to-one
  action=extract component props, variants, states from Penpot
  note=one Penpot component = one code component

rule design_complete_checklist:
  priority=high
  description="Explicit gating criteria before any UI code can be written"
  required_all=[
    "Every screen and its states defined in Penpot (wireframe+)",
    "Color palette extracted (primary, secondary, background, text, error, ...)",
    "Typography system extracted (font family, size scale, weights)",
    "Spacing system extracted (4px grid, scale values)",
    "Component hierarchy extracted (parent-child, variants, states)"
  ]
  action=verify each condition against Penpot MCP extraction result
  action=if any condition fails: "Design incomplete. Missing: [list]. Complete in Penpot first."
  forbidden=proceeding to UI code if any checklist item is missing

rule design_to_code_gate:
  priority=high
  trigger=Penpot design complete check passed, about to generate UI code
  action=1. Run design extraction via MCP POST http://localhost:{penpot_mcp_port}/mcp
  action=2. Convert extracted tokens to code-compatible format (CSS vars / Tailwind / theme object)
  action=3. Write token definitions to project files (e.g. src/styles/theme.ts)
  action=4. Report to user: "Penpot design extracted. Tokens committed to project."
  action=5. Begin component implementation
  verified=token definition file exists in project
  verified=all 5 checklist fields present in extraction output

rule design_change_handling:
  priority=medium
  trigger=design feedback or change request during implementation
  action=classify change: (A) token value only? -> edit code directly
  action=classify change: (B) new component, restructure, new screen? -> update Penpot -> re-extract MCP -> apply
  action=classify change: (C) existing token change (color rename, spacing scale change)? -> update Penpot -> re-extract -> bulk-replace across all components
  note=Boundary: single component prop = (A). Anything touching multiple components or layout = (B) or (C).

rule post_implementation_design_qa:
  priority=medium
  trigger=UI implementation complete, /review-work invoked
  action=compare implemented UI against Penpot design
  action=verify: colors match extracted tokens
  action=verify: typography matches extracted tokens
  action=verify: spacing matches extracted tokens
  action=verify: component structure matches Penpot component mapping
  action=on mismatch: fix code OR flag design discrepancy to user
