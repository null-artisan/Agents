# Git DSL
# Purpose: Branch naming, commit policy (message format, signing), PR policy (size, strategy),
#          merge/rebase/revert discipline, bisect discipline, branching model, hooks, gitignore,
#          secret scanning, force push protection, tag conventions, branch cleanup

rule branch_naming:
  priority=medium
  required=format: {type}/{description} (e.g., feat/user-auth, fix/login-error)
  allowed=types: feat, fix, hotfix, refactor, chore, docs, test, perf, ci

rule commit_policy:
  priority=medium
  required=one logical change per commit
  forbidden=WIP or save-point commits
  required=commit message explains what AND why
  trigger=commit created
  verify=message explains reasoning, not just content

rule pr_policy:
  priority=high
  required=commits and PRs only when explicitly requested
  approval=user must request commit or PR
  action=AI must not create commits or PRs without user instruction
  forbidden=creating commits or PRs proactively
  note=Enforcement: AI agent checks for explicit "commit" or "create PR" keywords before acting. If unclear, ask.

rule force_push_protection:
  priority=high
  forbidden=force push to main or master branches
  forbidden=force push to shared branches
  required=user confirmation before any destructive git operation
  approval=user must approve force push

rule secret_scanning:
  priority=high
  forbidden=committing secrets, .env files, or build artifacts
  required=check diff for secret patterns before staging
  verify=scan for credential patterns, API keys, tokens

rule merge_strategy:
  priority=medium
  required=squash merge for feature branches (linear history)
  allowed=merge commit for release branches
  allowed=rebase for personal branches before PR

rule commit_message_format:
  priority=medium
  required=Conventional Commits format: type(scope): description
  required=body explains what AND why
  see=git.dsl commit_policy
  allowed=types: feat, fix, refactor, chore, docs, test, perf, ci

rule branching_model:
  priority=medium
  preferred=trunk-based development (short-lived branches ≤2 days)
  allowed=GitFlow for release-managed projects
  required=branches target main (feature, fix) or release/* (hotfix)

rule bisect_discipline:
  priority=high
  required=every commit on main branch must compile and pass tests (bisectable)
  forbidden=committing code that doesn't compile to main
  allowed=feature/fix branches may have non-compiling intermediate commits during active development
  action=squash or rebase before merging to main to ensure a clean history

rule rebase_discipline:
  priority=medium
  allowed=interactive rebase on personal/unpushed branches only
  forbidden=rebasing shared/pushed branches
  action=if conflicts during rebase: resolve carefully, verify each resolution

rule git_hooks:
  priority=medium
  preferred=pre-commit hooks: lint + format + secret scan
  preferred=pre-push hooks: test gate
  forbidden=bypassing hooks with --no-verify without justification

rule gitignore_conventions:
  priority=medium
  required=.gitignore covers: OS files, IDE files, build output, dependency dirs
  forbidden=committing .env, credentials, or build artifacts

rule commit_signing:
  priority=medium
  preferred=sign commits with GPG or SSH key (git commit -S)
  see=security.dsl supply_chain_depth

rule pr_size:
  priority=medium
  preferred=PRs under 400 lines changed
  trigger=PR exceeds 400 lines
  action=suggest splitting into smaller PRs

rule tag_conventions:
  priority=medium
  required=annotated tags only (git tag -a)
  required=semver format: v1.2.3
  preferred=sign tags with GPG

rule revert_discipline:
  priority=high
  preferred=git revert for undoing changes on shared branches
  forbidden=git reset --hard on pushed/shared branches
  action=for local-only changes: git reset is acceptable

rule branch_cleanup:
  priority=medium
  required=delete branches after merge
  preferred=prune remote tracking branches regularly (git remote prune origin)
