# Contributing to {{PROJECT_NAME}}

## Spec-driven development

All feature work starts with a spec. We use [speckit](https://github.com/jwill824/speckit-personal) to keep development structured and documented.

### Workflow

```
/speckit.specify     → define what to build
/speckit.clarify     → resolve ambiguities
/speckit.plan        → break into milestones
/speckit.tasks       → break into actionable tasks
/speckit.implement   → build it
/speckit.analyze     → review and close the loop
```

Run `/speckit.constitution` at the start of a session to load project context.

### Starting a new feature

```bash
bash .specify/scripts/bash/create-new-feature.sh
```

This creates a spec branch and scaffolds the initial spec file.

### Spec files

Specs live in `.specify/` and are committed alongside the code they describe:

```
.specify/
  memory/
    constitution.md   ← project principles and constraints (project-specific)
    stack.md          ← tech stack reference
  templates/          ← symlinked from speckit-personal
  scripts/            ← symlinked from speckit-personal
```

## Pull requests

- Squash merge only — one commit per PR
- PR title should follow [Conventional Commits](https://www.conventionalcommits.org/)
- Link to the spec or issue in the PR description

## Updating speckit

```bash
git submodule update --remote .speckit
git add .speckit && git commit -m "chore: update speckit-personal to latest"
```
