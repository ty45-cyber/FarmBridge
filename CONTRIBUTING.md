# Contributing to FarmBridge

## Basics
- Follow Gitflow: `main` protected; create feature branches `feature/<short-desc>`.
- Commit messages: Conventional Commits (type(scope): subject).
- Tests: New features must include unit tests where applicable.

## PR process
1. Open PR against `develop` branch.
2. Assign reviewer and link Jira ticket.
3. CI must pass before merging.
4. Squash-and-merge with clear PR description and changelog entry.

## Code style
- Java: Google Java Format / Spring Boot conventions.
- Kotlin: Kotlin coding conventions.
- C++: clang-format with project style.

## Local dev
- Use `.env` for environment variables (don't commit secrets).
- Use `scripts/dev_setup.sh` to bootstrap the environment.

## Security
- Never commit secrets or API keys.
- Use GitHub Secrets for CI variables.
