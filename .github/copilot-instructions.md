# Copilot Instructions for [PROJECT_NAME]

This is a **spec-kit powered** project using spec-driven AI development. All non-trivial features follow the spec-kit lifecycle.

> Full constitution and principles: [`.specify/memory/constitution.md`](.specify/memory/constitution.md)
> Technology stack reference: [`.specify/memory/stack.md`](.specify/memory/stack.md)

---

## Commands

```bash
# [your build command here]
# [your test command here]
# [your lint command here]
```

---

## Architecture

```
[PROJECT_NAME]/
├── [describe your project structure here]
```

---

## Key Conventions

- Follow the project constitution in `.specify/memory/constitution.md`
- All features follow the spec-kit lifecycle (specify → clarify → plan → tasks → implement → analyze)
- Commit messages: Conventional Commits (`feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `perf`)
- Branch names: `NNN-short-description` where NNN is the zero-padded spec number

---

## Spec-Kit Workflow

All non-trivial features follow this lifecycle:

```
/speckit.specify    →  Write a feature spec from a natural language description
/speckit.clarify    →  Clarify ambiguous requirements before planning
/speckit.plan       →  Generate a technical implementation plan
/speckit.tasks      →  Break the plan into actionable tasks
/speckit.implement  →  Implement the tasks
/speckit.analyze    →  Analyze code quality and spec compliance
/speckit.review     →  AI-powered review before opening a PR
/speckit.checklist  →  Generate a pre-merge checklist
```

Agents are in `.github/agents/`. Prompts are in `.github/prompts/`.
