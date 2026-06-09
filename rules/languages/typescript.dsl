# TypeScript DSL
# Purpose: Type safety, imports, naming, exports, null/undefined handling, type placement, inference conventions

rule type_safety:
  priority=high
  see=AGENTS.md  # P0 — Never Violate: type error suppression (as any, @ts-ignore, @ts-expect-error) is forbidden
  required=refactor instead of suppressing types
  allowed=unknown type with narrowing (type guard, typeof, instanceof)
  review=check for type escapes during code review

rule type_preferences:
  priority=low
  preferred=interface over type for object shapes
  preferred=custom hooks over higher-order components (HOCs)

rule import_rules:
  priority=medium
  required=import order: standard library -> external packages -> internal absolute -> relative imports
  forbidden=wildcard imports except React and d3

rule export_rules:
  priority=medium
  required=one primary export per file (default export or main named export)

rule naming:
  priority=medium
  see=architecture.dsl  # naming_conventions rule covers universal naming (camelCase, PascalCase, snake_case, etc.)
  required=colocate by domain (files grouped by feature, not type)
  preferred=test file next to source file

rule null_undefined_handling:
  priority=medium
  required=prefer ?? over || for default values (|| treats empty string and 0 as falsy)
  required=use optional chaining (?.) for nested optional property access
  required=use discriminated unions for states that can be loading, success, or error
  forbidden=ignoring potential null or undefined without explicit handling
  review=check for implicit any from uncorrected optional access during code review

rule type_placement:
  priority=medium
  required=co-locate types with the component or module that defines them
  required=extract to shared types file only when 2 or more independent modules use the same type
  preferred=name shared type files as {domain}.types.ts (user.types.ts, post.types.ts)
  forbidden=putting all project types in a single types.ts at the project root

rule type_inference:
  priority=medium
  preferred=let TypeScript infer return types for internal functions and custom hooks
  required=explicitly annotate return types of exported functions, public APIs, and hook return values
  required=explicitly annotate function parameters (always)
  note=explicit return types on public APIs serve as documentation and catch implementation errors
