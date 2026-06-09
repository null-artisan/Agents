# Exceptions DSL
# Purpose: Defines when rules may be intentionally skipped, and how to document exceptions.
# Without this, every rule is absolute. Real projects need pragmatic exceptions.

rule exception_categories:
  priority=medium
  trigger=considering skipping a rule
  action=classify the exception into one of the four categories defined in this rule
  note=category_1="Prototype / Proof of Concept" -> may skip testing, accessibility, performance rules
  note=category_2="One-off script / migration" -> may skip architecture, testing rules
  note=category_3="Time-constrained hotfix" -> may skip testing, documentation rules (must follow up)
  note=category_4="Environment limitation" -> may skip rules requiring unavailable tools (e.g. no Penpot server)
  required=document which rule is being skipped and why
  forbidden=silently skipping rules without documenting the exception

rule exception_approval:
  priority=high
  trigger=any rule exception that is not category_4 (environment limitation)
  action=ask USER for explicit approval before skipping the rule
  action=state: "Skipping [rule] because [reason]. Proceed?"
  forbidden=assuming user would approve without asking
  note=Category 4 (environment) exceptions are pre-approved if the tool genuinely cannot run

rule exception_tracking:
  priority=low
  trigger=after creating an exception
  action=add comment at the point of exception: # EXCEPTION: [rule] - [reason] - [date]
  action=if category_3 (hotfix): add TODO to remove exception and fix properly
  note=untracked exceptions become permanent technical debt

rule no_exception_rules:
  priority=high
  description="Rules that cannot be skipped under any circumstances"
  never_except=[
    "P0 — Security (secrets, input validation, SQL injection)",
    "P0 — Honesty (never claim success without verification)",
    "P0 — No Guessing (do not invent files, APIs, or behavior)",
    "P0 — Design-First Penpot (the rule itself cannot be skipped; penpot.dsl defines a specific fallback for MCP unavailability)"
  ]
  note=These rules exist to prevent catastrophic failures. No exception is permitted.
  note=Penpot's mcp_availability fallback (ask user, get tokens manually) is the ONLY permitted exception flow.
