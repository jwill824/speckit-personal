<!-- Run /speckit.constitution to initialize this for your project -->

# Project Constitution: [PROJECT_NAME]

> **Version**: 1.0.0 | **Status**: Draft — run `/speckit.constitution` to initialize
> **Ratified**: [DATE]

---

## Preamble

[PROJECT_NAME] is [brief description of what this project does and why it exists].

This constitution defines the non-negotiable principles, architectural decisions, and development governance for [PROJECT_NAME]. All contributors (human and AI) are bound by these principles.

---

## Article I: Core Principles

These principles are **NON-NEGOTIABLE** and may not be violated without a formal amendment.

### I. [First Principle]
[Description of the first core principle]

### II. [Second Principle]
[Description of the second core principle]

### III. [Third Principle]
[Description of the third core principle]

### IV. Spec-Kit Workflow
All non-trivial features MUST follow the spec-kit lifecycle:
`/speckit.specify` → `/speckit.clarify` → `/speckit.plan` → `/speckit.tasks` → `/speckit.implement` → `/speckit.analyze`

---

## Article II: Architecture

### Technology Stack
See `.specify/memory/stack.md` for the full stack reference.

### Project Structure
```
[PROJECT_NAME]/
├── [describe your structure]
```

### Key Constraints
- [Architectural constraint 1]
- [Architectural constraint 2]

---

## Article III: Development Workflow

### Branching
- `main` — protected, always deployable
- Feature branches: `NNN-short-description`

### Commit Messages
Conventional Commits: `<type>(<scope>): <description>`
Types: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `perf`

### Pull Requests
- All changes via PRs
- Branch protection on `main`
- Squash merges only

---

## Article IV: Governance

### Amendments
Changes to this constitution require:
1. A feature spec (`/speckit.specify`)
2. Review and approval
3. Version bump and ratification date update

### Amendment Log
| Version | Date | Change |
|---------|------|--------|
| 1.0.0 | [DATE] | Initial constitution |
