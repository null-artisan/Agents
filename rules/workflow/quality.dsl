# Quality Workflow DSL
# Purpose: Error handling, safety & recovery, code review checklist, confidence threshold

rule error_prevention:
  priority=high
  preferred=prevent errors with types, validation, and immutability
  allowed=try/catch for network and I/O operations only
  forbidden=empty catch blocks
  required=structured error levels: debug, info, error
  required=error log includes: what failed, where, relevant context (no secrets)

rule fix_strategy:
  priority=high
  required=fix root cause, not symptom
  required=re-verify after every fix attempt
  forbidden=shotgun debugging (random changes hoping to fix)

rule verification:
  priority=high
  trigger=after write or edit operation
  action=run LSP diagnostics on changed files
  required=verify tool results explicitly
  forbidden=accepting "seems right" as evidence

rule failure_escalation:
  priority=high
  trigger=3 consecutive fix failures
  action=STOP all edits immediately
  action=REVERT to last known working state (git checkout / undo edits)
  action=DOCUMENT what was attempted and what failed
  action=CONSULT Oracle with full failure context
  action=if Oracle cannot resolve, ask user before proceeding
  forbidden=leaving code in broken state
  forbidden=continuing with more fix attempts after 3 failures

rule code_review_checklist:
  priority=high
  review=no type errors (no as any, @ts-ignore, @ts-expect-error)
  review=tests pass, new code includes tests
  review=scope discipline: every line traces to user request
  review=side effects and blast radius verified
  review=security: no secrets, no unsanitized input
  review=API spec updated (same PR)
  review=follows project conventions
  review=no AI slop (hallucinated APIs, dead code)
  review=import paths exist, no imaginary libraries

rule confidence_threshold:
  priority=high
  action=high confidence (full flow clear): implement directly
  action=medium confidence (unsure details): verify assumptions first
  action=low confidence (cannot trace flow): STOP and ask user
  note=low-confidence implementation is the #1 AI bug source
