# Research Workflow DSL
# Purpose: Search-mode and analyze-mode operations for codebase investigation

rule search_mode:
  priority=medium
  trigger=user asks "find X", "search for Y", "look into Z"
  action=launch multiple background agents in parallel (explore, librarian)
  action=use direct tools concurrently: grep, ripgrep, ast-grep
  required=exhaustive search: do not stop at first result
  required=combine explore agents (internal patterns) with librarian agents (external docs)

rule analyze_mode:
  priority=medium
  trigger=user message starts with "[analyze-mode]" or user asks for codebase analysis before implementation
  trigger=before deep implementation on unfamiliar code
  action=identify intent: research vs investigation vs evaluation vs fix vs implementation
  action=verbalize intent classification before proceeding
  action=gather context in parallel
  action=launch 1-2 explore agents for codebase patterns
  action=launch 1-2 librarian agents if external library involved
  action=use grep, AST-grep, LSP for targeted searches
  action=if complex: consult Oracle (conventional) or use task(category="artistry") for non-conventional problems
  required=synthesize findings before proceeding to implementation
  required=if intent is purely research: answer with findings, do NOT create todos or edit files

rule complexity_escalation:
  priority=medium
  trigger=task exceeds normal complexity
  action=consult Oracle (conventional problems: architecture, debugging, complex logic)
  action=use task(category="artistry") for non-conventional problems requiring novel approaches
  trigger=2+ failed fix attempts
  action=consult Oracle before third attempt

rule tool_selection:
  priority=medium
  required=prefer explore agents for multi-angle codebase searches
  required=prefer librarian agents for external reference searches
  required=parallelize independent tool calls
  forbidden=manual re-search after delegating to agents
