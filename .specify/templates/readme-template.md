# {{PROJECT_NAME}}

> {{SHORT_DESCRIPTION}}

## Overview

<!-- What does this project do? Who is it for? -->

## Getting started

```bash
git clone --recurse-submodules https://github.com/jwill824/{{REPO_NAME}}.git
cd {{REPO_NAME}}
```

## Development

See [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md) for the full development workflow.

## Updating speckit

This repo uses [speckit-personal](https://github.com/jwill824/speckit-personal) as a git
submodule at `.speckit/`. Dependabot opens a weekly PR to bump the ref automatically.

To update manually:

```bash
git submodule update --remote .speckit
git add .speckit && git commit -m "chore: update speckit-personal"
git push
```
