# Java DSL
# Purpose: Spring conventions, approved libraries, Java-specific rules

rule stack_policy:
  priority=medium
  required=Java only when more appropriate than Go
  exception=user explicitly requests Java
  review=justify why Go is insufficient before choosing Java

rule framework:
  priority=medium
  required=Spring Boot for web applications
  required=JPA (Hibernate) for ORM
  required=QueryDSL for type-safe queries
  preferred=latest LTS version for all dependencies

rule security:
  priority=medium
  see=platform/backend-spring.dsl  # security rule covers Spring Security + method-level auth

rule naming:
  priority=medium
  see=architecture.dsl  # naming_conventions covers universal naming (camelCase, PascalCase, etc.)
  required=PascalCase for file names (matching public class name)
  required=lowercase for package names (com.example.project)

rule validation:
  priority=medium
  required=Bean Validation (jakarta.validation) with Hibernate Validator

rule testing:
  priority=medium
  see=testing.dsl  # framework_selection rule covers JUnit 5 + Mockito
  preferred=JUnit 5 for unit and integration tests
  preferred=Mockito for mocking

rule code_quality:
  priority=medium
  see=platform/backend-spring.dsl  # code_quality rule covers Lombok, MapStruct, circular deps

rule static_analysis:
  priority=medium
  required=run static analysis in CI (SpotBugs, Checkstyle, or SonarQube)
  required=configure rules for: security hotspots, null pointer safety, resource leaks, coding standards
  preferred=SonarQube quality gate must pass before merge
