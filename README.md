# speckit-personal

[![spec-kit powered](https://img.shields.io/badge/spec--kit-powered-blueviolet)](https://github.com/github/spec-kit)

A personal [spec-kit](https://github.com/github/spec-kit) extension and GitHub template repository for spec-driven AI development. Use it as a template for new projects or install it as an extension into existing ones.

## What Is This?

`speckit-personal` packages a complete spec-driven development workflow into a reusable GitHub template. It includes:

- **Agents** — AI agents for every stage of the spec-kit lifecycle
- **Prompts** — slash-command prompts for VS Code / Copilot Chat
- **Skills** — reusable skill modules (conventional-commit, context-map, github-issues)
- **Hooks** — session-logger for automatic Copilot session logging
- **Templates** — spec, plan, tasks, constitution, and stack templates

## Spec-Kit Workflow

```
/speckit.constitution  →  Initialize your project constitution
/speckit.specify       →  Write a feature spec from natural language
/speckit.clarify       →  Clarify ambiguous requirements
/speckit.plan          →  Generate a technical implementation plan
/speckit.tasks         →  Break the plan into actionable tasks
/speckit.implement     →  Implement the tasks one by one
/speckit.analyze       →  Analyze code quality and spec compliance
/speckit.review        →  AI-powered PR review before opening
/speckit.checklist     →  Generate a pre-merge checklist
```

## Using as a GitHub Template

Click **"Use this template"** at the top of this repository to create a new repo with all files pre-populated.

After creating your repo:
1. Open the project in VS Code
2. Run `/speckit.constitution` in Copilot Chat to initialize your project constitution
3. Start building with `/speckit.specify`

## Using as a spec-kit Extension

```bash
# In your existing project directory
bash <(curl -fsSL https://raw.githubusercontent.com/jwill824/speckit-personal/main/install.sh)
```

Or clone and install locally:
```bash
git clone https://github.com/jwill824/speckit-personal.git
cd speckit-personal
bash install.sh /path/to/your/project
```

## What's Included

### Agents (`.github/agents/`)

> `install.sh` creates `.github/agents/` as a **real directory** with each speckit agent
> individually symlinked. This lets you add repo-specific agents alongside speckit agents
> without modifying the submodule — just commit `.github/agents/my-agent.agent.md` directly.

| Agent | Command | Purpose |
|-------|---------|---------|
| `speckit.constitution.agent.md` | `/speckit.constitution` | Initialize project constitution |
| `speckit.specify.agent.md` | `/speckit.specify` | Write feature specs |
| `speckit.clarify.agent.md` | `/speckit.clarify` | Clarify requirements |
| `speckit.plan.agent.md` | `/speckit.plan` | Generate implementation plans |
| `speckit.tasks.agent.md` | `/speckit.tasks` | Break plans into tasks |
| `speckit.implement.agent.md` | `/speckit.implement` | Implement tasks |
| `speckit.analyze.agent.md` | `/speckit.analyze` | Analyze code quality |
| `speckit.review.agent.md` | `/speckit.review` | AI PR review |
| `speckit.checklist.agent.md` | `/speckit.checklist` | Pre-merge checklist |
| `speckit.taskstoissues.agent.md` | `/speckit.taskstoissues` | Convert tasks to GitHub Issues |
| `issue-triage.agent.md` | `/issue-triage` | Triage GitHub Issues |

### Skills (`.github/skills/`)
- **conventional-commit** — enforces conventional commit message format
- **context-map** — generates a codebase context map for AI agents
- **github-issues** — GitHub Issues best practices and reference docs

### Hooks (`.github/hooks/session-logger/`)
Automatically logs Copilot session start/end and each prompt to `logs/`. Great for reviewing AI-assisted development sessions.

### Templates (`.specify/templates/`)
- `constitution-template.md` — project constitution template
- `stack-template.md` — technology stack reference
- `spec-template.md` — feature specification
- `plan-template.md` — implementation plan
- `tasks-template.md` — task breakdown
- `agent-file-template.md` — custom agent template
- `checklist-template.md` — pre-merge checklist

## Community Extensions

Pair this with these community extensions for a complete workflow:

| Extension | Purpose |
|-----------|---------|
| [spec-kit-checkpoint](https://github.com/aaronrsun/spec-kit-checkpoint) | Save and restore spec-kit state |
| [spec-kit-cleanup](https://github.com/dsrednicki/spec-kit-cleanup) | Clean up stale specs and plans |
| [spec-kit-status](https://github.com/KhawarHabibKhan/spec-kit-status) | Show workflow progress dashboard |
| [spec-kit-doctor](https://github.com/KhawarHabibKhan/spec-kit-doctor) | Diagnose spec-kit health issues |

## Links

- [spec-kit (GitHub)](https://github.com/github/spec-kit)
- [GitHub Copilot Docs](https://docs.github.com/copilot)
