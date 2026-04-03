#!/usr/bin/env bash
# install.sh — Bootstrap speckit-personal as a git submodule in a target repository.
#
# Usage: bash <(curl -fsSL https://raw.githubusercontent.com/jwill824/speckit-personal/main/install.sh) [TARGET_DIR]
#   or:  bash install.sh [TARGET_DIR]
#
# What this does:
#   1. Adds jwill824/speckit-personal as a git submodule at .speckit/
#   2. Creates symlinks so speckit tooling resolves from expected paths:
#        .github/agents/     ← real directory; each agent individually symlinked so
#                               repo-specific agents can live alongside speckit agents
#        .github/prompts   → ../.speckit/.github/prompts
#        .github/skills    → ../.speckit/.github/skills
#        .github/hooks     → ../.speckit/.github/hooks
#        .specify/templates → ../.speckit/.specify/templates
#        .specify/scripts   → ../.speckit/.specify/scripts
#   3. Creates LOCAL project-specific stubs (never submoduled):
#        .specify/memory/constitution.md  ← fill via /speckit.constitution
#        .specify/memory/stack.md         ← fill via /speckit.constitution
#        .github/copilot-instructions.md  ← customize for your project
#
# To update speckit across all repos:
#   git submodule update --remote .speckit
#   git add .speckit && git commit -m "chore: update speckit-personal"

set -euo pipefail

SPECKIT_REPO="https://github.com/jwill824/speckit-personal.git"
SUBMODULE_PATH=".speckit"
TARGET_DIR="${1:-$(pwd)}"

# ── Colours ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

info()    { echo -e "  ${CYAN}→${RESET}  $*"; }
success() { echo -e "  ${GREEN}✓${RESET}  $*"; }
warn()    { echo -e "  ${YELLOW}⚠${RESET}  $*"; }
error()   { echo -e "  ${RED}✗${RESET}  $*" >&2; exit 1; }

echo -e "\n${BOLD}🔧 speckit-personal installer${RESET}\n"

# ── Preflight ──────────────────────────────────────────────────────────────────
cd "$TARGET_DIR" || error "Cannot cd to $TARGET_DIR"
git rev-parse --git-dir &>/dev/null || error "$TARGET_DIR is not a git repository. Run 'git init' first."

echo -e "${BOLD}Target:${RESET} $(pwd)"
echo ""

# ── 1. Submodule ───────────────────────────────────────────────────────────────
echo -e "${BOLD}Step 1: Submodule${RESET}"
if git config --file .gitmodules "submodule.${SUBMODULE_PATH}.url" &>/dev/null 2>&1; then
  warn ".speckit submodule already registered — updating"
  git submodule update --init --remote "$SUBMODULE_PATH"
  success "Submodule up to date"
else
  info "Adding $SPECKIT_REPO → $SUBMODULE_PATH"
  git submodule add "$SPECKIT_REPO" "$SUBMODULE_PATH"
  git submodule update --init "$SUBMODULE_PATH"
  success "Submodule added at .speckit/"
fi
echo ""

# ── 2. Symlinks ────────────────────────────────────────────────────────────────
echo -e "${BOLD}Step 2: Symlinks${RESET}"

# agents: real directory with individual file symlinks so repo-specific agents
# can be added alongside speckit agents without touching the submodule.
if [ -L ".github/agents" ]; then
  warn ".github/agents is a directory symlink — skipping (remove it first to migrate to individual symlinks)"
elif [ ! -d ".github/agents" ]; then
  mkdir -p .github/agents
fi

if [ -d ".github/agents" ] && [ ! -L ".github/agents" ]; then
  for src in .speckit/.github/agents/*; do
    fname="$(basename "$src")"
    link=".github/agents/$fname"
    if [ -L "$link" ]; then
      warn "$link already exists — skipping"
    else
      ln -s "../../.speckit/.github/agents/$fname" "$link"
      success "Linked $link → ../../.speckit/.github/agents/$fname"
    fi
  done
fi

# prompts, skills, hooks: directory symlinks (no repo-specific overrides needed)
declare -A LINKS=(
  [".github/prompts"]="../.speckit/.github/prompts"
  [".github/skills"]="../.speckit/.github/skills"
  [".github/hooks"]="../.speckit/.github/hooks"
  [".specify/templates"]="../.speckit/.specify/templates"
  [".specify/scripts"]="../.speckit/.specify/scripts"
)

for link in "${!LINKS[@]}"; do
  target="${LINKS[$link]}"
  mkdir -p "$(dirname "$link")"

  if [ -L "$link" ]; then
    warn "$link symlink already exists — skipping"
    continue
  fi

  if [ -e "$link" ] && [ ! -L "$link" ]; then
    warn "$link exists as a real path — skipping (remove it first to use the submodule version)"
    continue
  fi

  ln -s "$target" "$link"
  success "Linked $link → $target"
done
echo ""

# ── 3. Local project-specific stubs ───────────────────────────────────────────
echo -e "${BOLD}Step 3: Project-specific stubs${RESET}"
mkdir -p .specify/memory .github/workflows specs

_stub() {
  local path="$1"; local label="$2"
  if [ -f "$path" ]; then
    warn "$path already exists — skipping"
  else
    shift 2
    mkdir -p "$(dirname "$path")"
    printf '%s\n' "$@" > "$path"
    success "Created $path  ($label)"
  fi
}

_stub ".specify/memory/constitution.md" "fill via /speckit.constitution" \
  "<!-- Run /speckit.constitution to initialize this for your project -->" \
  "" \
  "$(cat .speckit/.specify/templates/constitution-template.md 2>/dev/null || echo '# [PROJECT_NAME] Constitution')"

_stub ".specify/memory/stack.md" "fill via /speckit.constitution" \
  "<!-- Run /speckit.constitution to detect and populate your stack -->" \
  "" \
  "$(cat .speckit/.specify/templates/stack-template.md 2>/dev/null || echo '# Project Stack')"

_stub ".specify/memory/issues-backlog.md" "auto-updated by speckit" \
  "# GitHub Issues Backlog" \
  "<!-- Auto-updated by /speckit.specify via issue-triage agent -->" \
  "<!-- last_refreshed: never -->" \
  "" \
  "| Issue | Title | Status | Linked Spec |" \
  "|-------|-------|--------|-------------|"

_stub ".github/copilot-instructions.md" "customize for your project" \
  "# Copilot Instructions" \
  "" \
  "<!-- TODO: Replace with your project-specific Copilot instructions. -->" \
  "<!-- Run /speckit.constitution first, then update this file. -->" \
  "" \
  "This project uses spec-driven development via [speckit-personal](https://github.com/jwill824/speckit-personal)." \
  "" \
  "## Spec-Kit Workflow" \
  "" \
  "\`/speckit.specify\` → \`/speckit.clarify\` → \`/speckit.plan\` → \`/speckit.tasks\` → \`/speckit.implement\` → \`/speckit.analyze\`" \
  "" \
  "## Project Constitution" \
  "" \
  "See \`.specify/memory/constitution.md\` for governing principles." \
  "" \
  "## Stack" \
  "" \
  "See \`.specify/memory/stack.md\` for tooling and commands."

echo ""

# ── 4. .gitignore ─────────────────────────────────────────────────────────────
echo -e "${BOLD}Step 4: .gitignore${RESET}"
GITIGNORE=".gitignore"
touch "$GITIGNORE"
for entry in "logs/" ".env" ".env.local"; do
  if ! grep -qF "$entry" "$GITIGNORE"; then
    echo "$entry" >> "$GITIGNORE"
    success "Added $entry to .gitignore"
  fi
done
echo ""

# ── Done ──────────────────────────────────────────────────────────────────────
echo -e "${BOLD}${GREEN}✅  speckit-personal installed!${RESET}"
echo ""
echo -e "  ${BOLD}Next steps:${RESET}"
echo -e "  1. ${CYAN}/speckit.constitution${RESET}  — initialize your project constitution & stack"
echo -e "  2. ${CYAN}/speckit.specify${RESET}        — write your first feature spec"
echo ""
echo -e "  ${BOLD}To update speckit later:${RESET}"
echo -e "  ${CYAN}git submodule update --remote .speckit${RESET}"
echo -e "  ${CYAN}git add .speckit && git commit -m \"chore: update speckit-personal\"${RESET}"
echo ""
