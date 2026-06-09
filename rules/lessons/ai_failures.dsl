# AI Failures DSL
# Purpose: Known AI failure patterns with detection and prevention rules

rule signature_drift:
  priority=high
  description=changing function signature without updating all callers
  trigger=after changing function signature
  action=grep for all call sites of the function
  verify=every caller matches new signature
  review=check for missed callers during code review

rule import_hallucination:
  priority=high
  description=generating imports from non-existent paths or wrong packages
  trigger=after writing import statements
  action=verify import paths resolve to actual files
  action=especially check framework objects (e.g., NextRequest) from wrong packages
  verify=run LSP diagnostics immediately after writing imports
  review=check every import line during code review

rule type_escape:
  priority=high
  description=using as any, @ts-ignore under stress despite hard block
  trigger=after any implementation task
  action=scan code for as any, @ts-ignore, @ts-expect-error
  review=mandatory check during code review

rule context_amnesia:
  priority=medium
  description=forgetting early decisions (naming, patterns, conventions) during long tasks
  trigger=long task (more than 5 steps)
  action=pin key decisions as inline code comments
  action=reference decision comments when writing related code
  verify=consistency check: does new code follow early decisions?

rule over_engineering:
  priority=medium
  description=creating unnecessary abstractions (interfaces with 1 impl, speculative patterns)
  trigger=after implementation task
  action=audit new files: is abstraction justified by immediate need?
  forbidden=speculative abstractions for hypothetical future needs

rule premature_refactoring:
  priority=high
  description=refactoring unrelated code during bug fix or feature task
  trigger=bug fix or feature addition task
  action=check diff scope: changes limited to issue-related files?
  forbidden=renaming or restructuring during a fix without user request

rule test_drift:
  priority=high
  description=updating test expectations to match broken code instead of fixing the code
  trigger=after test failure following implementation change
  action=require explanation: "why was the original expected value wrong?"
  forbidden=changing test assertions to match broken implementation

rule hallucinated_documentation:
  priority=high
  description=documenting APIs, endpoints, or features that don't exist in codebase
  trigger=after writing documentation (README, JSDoc, OpenAPI)
  action=verify every documented endpoint exists in route definitions
  action=verify every @param matches actual function signature

rule silent_fallback:
  priority=high
  description=silently switching to fallback approach when primary plan fails
  trigger=after encountering an error or obstacle during implementation
  action=report failure explicitly: what failed, why, and alternative
  action=wait for user approval before proceeding with fallback

rule confirmation_bias:
  priority=high
  description=agreeing with user's incorrect assumption instead of verifying
  trigger=user states assertion or proposes solution direction
  action=verify user's factual claims against actual codebase before acting
  forbidden=implementing based on unverified user assumption

rule false_confidence:
  priority=high
  description=claiming correctness without verification evidence
  trigger=after proposing solution or generating code
  action=every confidence claim must cite supporting evidence (test pass, type check)
  forbidden=phrases like "this should work" without verification

rule premature_optimization:
  priority=medium
  description=optimizing code (caching, memoization, async) without evidence of bottleneck
  trigger=implementation task without performance requirement
  action=use simplest correct implementation on first pass
  forbidden=adding optimization without profiling evidence

rule dependency_creep:
  priority=medium
  description=adding unnecessary library dependencies for trivial functionality
  trigger=before adding new dependency
  action=check if standard library can do the job in ≤10 lines
  verify=every new dependency is used in 2+ places OR has complex justification

rule zombie_code_generation:
  priority=medium
  description=generating unreachable or unused code
  trigger=after creating new file or significant code block
  action=run LSP find references on every public symbol
  action=remove or justify unused code

rule invention_prevention:
  priority=high
  description="AI must not invent behavior, requirements, or project structure that doesn't exist"
  trigger=before generating code, documentation, or configuration
  action=verify every referenced behavior/feature exists in actual codebase
  action=verify every requirement stated in the task/user message — do not infer
  action=verify every file path and directory structure matches actual project layout
  forbidden=generating code that references non-existent APIs, endpoints, or functions
  forbidden=adding implicit requirements the user never stated
  forbidden=creating files or directories the user did not request
  verify=every claimed behavior traces to real code (grep or read to confirm)

rule assumptions_discipline:
  priority=high
  description="Assumptions must be clearly labeled and verified, never silently treated as facts"
  trigger=when encountering ambiguous or missing information during a task
  action=explicitly label every assumption with "[ASSUMPTION]: ..." in your reasoning
  action=separate verified facts from assumptions in all communication
  action=verify assumptions at the next practical opportunity (read file, ask user, grep codebase)
  forbidden=silently proceeding on an unverified assumption
  forbidden=treating an assumption as a fact in code, docs, or communication
  required=if an assumption cannot be verified, ask the user before proceeding

rule premature_implementation:
  priority=high
  description=starting implementation when user only asked for analysis or research
  trigger=user message begins with "[analyze-mode]" or contains "look into" / "investigate" / "check" / "find out"
  action=classify intent before acting: analysis request != implementation request
  required=if intent is analysis only: do NOT create todos, edit files, or write code
  forbidden=proceeding to implementation after analysis-mode request without explicit user go-ahead
  verify=before any tool call that modifies files: re-check user intent was implementation
