# Governance Maintenance DSL
# Purpose: Rules for maintaining AGENTS.md and DSL rule files

rule content_addition:
  priority=high
  trigger=AI finds content suitable for AGENTS.md or DSL
  action=notify USER and get approval before adding
  forbidden=modifying AGENTS.md or DSL files without USER approval

rule obsidian_sync:
  priority=medium
  trigger=AGENTS.md or rules/ directory modified
  action=check env OBSIDIAN_PATH
  action=if OBSIDIAN_PATH set: sync to that directory
  action=else: search $env:LOCALAPPDATA\Obsidian for vault config
  action=if vault found: copy AGENTS.md and rules/ to vault
  note=skip if Obsidian not installed

rule conflict_resolution:
  priority=high
  trigger=project-level AGENTS.md contains rules conflicting with global AGENTS.md
  action=ask USER which to follow
  forbidden=silently picking one side

rule review_cycle:
  priority=medium
  required=review AGENTS.md and DSL files quarterly or per major project
  trigger=start of Q1/Q3 or before first session after >30 day gap
  action=offer to run full review
  trigger=rule never violated in 2+ quarters
  action=consider downgrading its priority tier
  note=Quarterly review is enforced by the AI workflow: check last review date before any rule modification

rule mistake_log:
  priority=medium
  trigger=AI makes a repeated mistake in a project
  action=USER should add it to that project's AGENTS.md as a known gotcha
  note=prevents the same error across sessions

rule priority_mapping_enforcement:
  priority=high
  description="Maps DSL priority values to Constitution tiers. All DSL rules MUST use this mapping."
  mapping=[
    "priority=high  -> Constitution P0 (Never Violate): fatal errors, security, design-first, data integrity",
    "priority=medium -> Constitution P1 (Ask Before Proceeding): architecture decisions, API changes, config changes",
    "priority=low   -> Constitution P2 (Preferred Behavior): style preferences, optimization, conventions"
  ]
  trigger=creating or editing any DSL rule
  action=check priority value against the rule's actual content
  action=if content describes a hard requirement -> must use priority=high
  action=if content describes something needing user approval -> must use priority=medium
  action=if content describes a preference or style -> must use priority=low
  action=if content contains forbidden= rules -> minimum priority=medium
  forbidden=using "P0", "P1", "P2" as priority values in DSL files (use high/medium/low)
  forbidden=using priority=high for cosmetic or preference rules
  forbidden=using priority=low for security, data integrity, or correctness rules
  see=AGENTS.md Priority Levels section for complete mapping reference
