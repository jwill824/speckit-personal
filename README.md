# copilot-kit

GitHub Copilot agents, prompts, skills, and hooks — composable Copilot tooling for spec-driven AI development.

Used as a git submodule (at `.copilot/`) to provide:

- `.github/agents/` — Copilot agents for every stage of the spec-kit lifecycle
- `.github/prompts/` — slash-command prompts for VS Code / Copilot Chat
- `.github/skills/` — reusable skill modules
- `.github/hooks/` — session-logger hook

## Composable Kit Architecture

`copilot-kit` is the Copilot tooling layer. Pair it with:

| Kit | Submodule path | Provides |
|-----|---------------|---------|
| [speckit-core](https://github.com/jwill824/speckit-core) | `.speckit/` | spec-kit templates, scripts, memory stubs |
| `claude-kit` *(coming soon)* | `.claude/` | Claude-specific tooling |

> **Note:** `speckit.*` agents reference `.specify/templates/` which is provided by `speckit-core`.
> When used without `speckit-core`, those agents are automatically skipped at bootstrap time.
>
> When paired with `speckit-core`, this repo now exposes `.specify/ai-kit.manifest.json` so the generic
> linker in `speckit-core` can attach Copilot-owned files without hardcoding `.github/*` logic in every consumer.

## Usage

### Via github-repo-factory (Recommended)

Set `ai_tool: "copilot"` (and `spec_workflow: true` if using speckit) in your `repos.json` entry — the bootstrap workflow handles everything automatically.

### Manual Installation

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/jwill824/copilot-kit/main/install.sh)
```

If `.speckit/` is already present, the installer delegates to:

```bash
bash .speckit/.specify/scripts/bash/link-ai-integration.sh copilot .copilot
```

If `speckit-core` is not present, `copilot-kit` falls back to its standalone linking behavior.

## Spec-Kit Workflow

```
/speckit.constitution  →  /speckit.specify  →  /speckit.clarify
/speckit.plan          →  /speckit.tasks    →  /speckit.implement  →  /speckit.analyze
```

## What's Included

### Agents (`.github/agents/`)

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

### Prompts (`.github/prompts/`)

Slash-command prompts for each spec-kit lifecycle phase plus issue-triage.

### Skills (`.github/skills/`)

- **conventional-commit** — enforces conventional commit message format
- **context-map** — generates a codebase context map for AI agents
- **github-issues** — GitHub Issues best practices and reference docs

### Hooks (`.github/hooks/session-logger/`)

Automatically logs Copilot session start/end and each prompt to `logs/`.

## Links

- [speckit-core](https://github.com/jwill824/speckit-core) — spec-kit templates and scripts
- [github-repo-factory](https://github.com/jwill824/github-repo-factory) — Terraform-managed repo factory
- [GitHub Copilot Docs](https://docs.github.com/copilot)
