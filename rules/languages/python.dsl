# Python DSL
# Purpose: Python toolchain, project conventions, type hints policy, testing, dependency management

rule toolchain:
  priority=medium
  required=pyproject.toml as single config file (no setup.py/setup.cfg)
  required=ruff for linting and formatting
  required=mypy --strict for type checking
  required=pytest for testing
  preferred=uv for package and environment management (replaces pip/venv/poetry)
  allowed=pip + venv for existing projects; new projects should use uv
  preferred=latest stable Python 3.x for all new projects

rule project_structure:
  priority=medium
  required=src-layout: src/<package>/, not flat
  required=tests/unit/ and tests/integration/ directories
  required=py.typed marker for PEP 561 compliance
  required=__init__.py with explicit __all__ for public API surface
  preferred=__main__.py for CLI entry points (python -m <package>)
  preferred=conftest.py for shared fixtures at appropriate directory levels

rule type_hints:
  priority=medium
  required=mypy --strict in CI
  required=disallow_untyped_defs = true
  required=all public functions and methods have type annotations
  required=annotate return types on all public APIs
  allowed=overrides for tests: disallow_untyped_defs = false
  preferred=use X | Y syntax (PEP 604) over Union[X, Y]
  preferred=use list[X] over List[X], dict[K, V] over Dict[K, V] (PEP 585)

rule linting_formatting:
  priority=medium
  required=ruff check --fix on every commit + CI gate
  required=ruff format on every commit + CI gate
  required=line-length = 88

rule testing:
  priority=medium
  see=testing.dsl  # framework_selection rule covers Python: pytest
  preferred=fixtures for shared setup (not setUpClass)
  preferred=pytest.mark.parametrize for input matrices
  preferred=conftest.py for fixture discovery and shared configuration
  required=coverage >= 80%

rule dependencies:
  priority=medium
  required=uv.lock committed to VCS
  required=all deps in [project.dependencies] or [project.optional-dependencies]
  required=ruff check for unused dependencies
  forbidden=committing both requirements.txt and pyproject.toml
  required=python version constraint in [project.requires-python]

rule naming:
  priority=medium
  see=architecture.dsl  # naming_conventions covers PascalCase for classes, UPPER_SNAKE_CASE for constants, snake_case for file names
  required=snake_case for variables, functions, and module names (overrides architecture.dsl naming_conventions camelCase default)
  required=one underscore prefix for internal/private (_internal_fn)
  forbidden=double underscore prefix except name mangling (__only_for_mixin_patterns)
