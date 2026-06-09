# CLI Platform DSL
# Purpose: Command-line tool and script conventions

rule stack_choice:
  priority=medium
  preferred=Go for CLI tools (single binary, fast startup, cross-platform)
  allowed=Python for scripting when Go is overkill
  trigger=CLI requires external library exclusive to Python
  action=use Python, document reason

rule conventions:
  priority=low
  preferred=POSIX-compliant argument parsing (Go: cobra/pflag)
  preferred=environment variables for configuration
  preferred=colored output with --no-color flag

rule output_format:
  priority=medium
  required=support --output json|table|plain for structured data
  required=JSON output default when piped (non-TTY detection)

rule exit_codes:
  priority=high
  required=0 for success, 1 for generic error, 2 for misuse/bad args
  required=never exit 0 on failure

rule io_discipline:
  priority=high
  required=machine output → stdout, diagnostics/errors → stderr
  required=--quiet suppresses stderr noise
  required=--json emits only stdout JSON, no log lines
  forbidden=mixing data and diagnostic output to stdout

rule error_messages:
  priority=high
  required=format: "error: <description>" with relevant context
  required=--verbose for stack traces
  preferred=include suggestion for fix when possible

rule help_text:
  priority=medium
  required=synopsis line, description, flags with types+defaults, examples section
  required=auto-generated from argument parser (--help)

rule subcommand_conventions:
  priority=medium
  preferred=noun-verb pattern (tool user create, tool config list)
  preferred=--help on every subcommand, max 2 levels deep

rule config_file:
  priority=medium
  required=XDG Base Directory spec ($XDG_CONFIG_HOME/tool/config.toml)
  required=--config flag to override

rule verbosity:
  priority=medium
  required=standard levels: error, warn, info, debug, trace
  required=-v/-vv/--verbose/--silent flags
  forbidden=using fmt.Print for debug output — use structured logging
