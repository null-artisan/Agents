# Go DSL
# Purpose: Preferred libraries, project conventions, Go-specific rules

rule stack_default:
  priority=medium
  preferred=Go (Gin) for web backend
  trigger=library is exclusive to Python
  action=use Python instead, document reason

rule preferred_libraries:
  priority=medium
  required=HTTP framework: Gin
  required=ORM: GORM
  required=configuration: Viper
  required=logging: zap
  required=validation: go-playground/validator
  required=JWT: golang-jwt/jwt
  preferred=access control: casbin
  allowed=custom middleware for simpler access control needs

rule naming:
  priority=medium
  see=architecture.dsl  # naming_conventions covers universal rules (camelCase variables, PascalCase types, snake_case files)
  required=camelCase for unexported constants (maxRetryCount)
  required=PascalCase for exported constants (MaxRetryCount)
  note=Go does not use UPPER_SNAKE_CASE for constants; this overrides architecture.dsl naming_conventions

rule testing:
  priority=medium
  see=testing.dsl  # framework_selection rule covers Go: testing package + testify
  preferred=testing package (standard library)
  preferred=testify for assertions and mocking

rule static_analysis:
  priority=medium
  required=run golangci-lint in CI pipeline
  required=configure linters for: unused code, security issues, performance issues, style violations
  preferred=fail CI build on linting errors (or enforce in code review if too strict)
