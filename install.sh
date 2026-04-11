#!/usr/bin/env bash
# install.sh — Bootstrap copilot-kit as a git submodule in a target repository.
#
# Usage: bash <(curl -fsSL https://raw.githubusercontent.com/jwill824/copilot-kit/main/install.sh) [TARGET_DIR]
#   or:  bash install.sh [TARGET_DIR]

set -euo pipefail

COPILOT_REPO="https://github.com/jwill824/copilot-kit.git"
SUBMODULE_PATH=".copilot"
TARGET_DIR="${1:-$(pwd)}"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

info()    { echo -e "  ${CYAN}→${RESET}  $*"; }
success() { echo -e "  ${GREEN}✓${RESET}  $*"; }
warn()    { echo -e "  ${YELLOW}⚠${RESET}  $*"; }
error()   { echo -e "  ${RED}✗${RESET}  $*" >&2; exit 1; }

write_project_tooling() {
  local path=".specify/project-tooling.json"
  local tmp
  tmp="$(mktemp)"

  mkdir -p .specify

  if [ -f "$path" ]; then
    # Merge: preserve spec_workflow and other keys, update ai_tool + ai_kit_path
    python3 - "$path" "$tmp" <<'PY'
import json, sys
data = json.load(open(sys.argv[1]))
data.setdefault("spec_workflow", True)
data["ai_tool"] = "copilot"
data["ai_kit_path"] = ".copilot"
json.dump(data, open(sys.argv[2], "w"), indent=2)
open(sys.argv[2], "a").write("\n")
PY
    mv "$tmp" "$path"
    success "Updated $path"
  else
    cat > "$path" <<'JSON'
{
  "spec_workflow": true,
  "ai_tool": "copilot",
  "ai_kit_path": ".copilot"
}
JSON
    success "Created $path"
  fi
}

echo -e "\n${BOLD}🔧 copilot-kit installer${RESET}\n"

cd "$TARGET_DIR" || error "Cannot cd to $TARGET_DIR"
git rev-parse --git-dir &>/dev/null || error "$TARGET_DIR is not a git repository."

echo -e "${BOLD}Target:${RESET} $(pwd)\n"

# ── 1. Submodule ───────────────────────────────────────────────────────────────
echo -e "${BOLD}Step 1: Submodule${RESET}"
if git config --file .gitmodules "submodule.${SUBMODULE_PATH}.url" &>/dev/null 2>&1; then
  warn ".copilot submodule already registered — updating"
  git submodule update --init --remote "$SUBMODULE_PATH"
else
  info "Adding $COPILOT_REPO → $SUBMODULE_PATH"
  git submodule add "$COPILOT_REPO" "$SUBMODULE_PATH"
  git submodule update --init "$SUBMODULE_PATH"
fi
success "Submodule ready at .copilot/\n"

if [ -x ".speckit/.specify/scripts/bash/link-ai-integration.sh" ] && [ -f ".copilot/.specify/ai-kit.manifest.json" ]; then
  echo -e "${BOLD}Step 2: Generic integration linking${RESET}"
  bash ".speckit/.specify/scripts/bash/link-ai-integration.sh" copilot .copilot
  # linker writes project-tooling.json automatically
  echo ""

  echo -e "${BOLD}${GREEN}✅  copilot-kit installed!${RESET}\n"
  echo -e "  ${BOLD}Next:${RESET} customize ${CYAN}.github/copilot-instructions.md${RESET} for your project"
  echo -e "  ${BOLD}Update later:${RESET} ${CYAN}git submodule update --remote .copilot${RESET}\n"
  exit 0
fi

# ── 2. Agent symlinks (individual files) ──────────────────────────────────────
echo -e "${BOLD}Step 2: Agent symlinks${RESET}"
if [ -L ".github/agents" ]; then
  warn ".github/agents is a symlink — skipping (remove it to migrate to individual symlinks)"
elif [ ! -d ".github/agents" ]; then
  mkdir -p .github/agents
fi

if [ -d ".github/agents" ] && [ ! -L ".github/agents" ]; then
  SPECKIT_PRESENT=false
  [ -d ".speckit" ] && SPECKIT_PRESENT=true

  for src in .copilot/.github/agents/*; do
    fname="$(basename "$src")"
    # Skip speckit.* agents if speckit-core is not bootstrapped
    if [[ "$fname" == speckit.* ]] && [ "$SPECKIT_PRESENT" = false ]; then
      warn "Skipping $fname (speckit-core not present)"
      continue
    fi
    link=".github/agents/$fname"
    if [ -L "$link" ]; then
      warn "$link already exists — skipping"
    else
      ln -s "../../.copilot/.github/agents/$fname" "$link"
      success "Linked $link"
    fi
  done
fi
echo ""

# ── 3. Directory symlinks ─────────────────────────────────────────────────────
echo -e "${BOLD}Step 3: Directory symlinks${RESET}"
declare -A LINKS=(
  [".github/prompts"]="../.copilot/.github/prompts"
  [".github/skills"]="../.copilot/.github/skills"
  [".github/hooks"]="../.copilot/.github/hooks"
)

for link in "${!LINKS[@]}"; do
  target="${LINKS[$link]}"
  mkdir -p "$(dirname "$link")"
  if [ -L "$link" ]; then
    warn "$link already exists — skipping"
  elif [ -e "$link" ]; then
    warn "$link exists as real path — skipping"
  else
    ln -s "$target" "$link"
    success "Linked $link → $target"
  fi
done
echo ""

# ── 4. Copilot instructions stub ──────────────────────────────────────────────
echo -e "${BOLD}Step 4: Project stubs${RESET}"
if [ -f ".github/copilot-instructions.md" ]; then
  warn ".github/copilot-instructions.md already exists — skipping"
else
  cat > .github/copilot-instructions.md << 'STUB'
# Copilot Instructions

<!-- TODO: Replace with your project-specific Copilot instructions. -->

This project uses spec-driven development via [speckit-core](https://github.com/jwill824/speckit-core) + [copilot-kit](https://github.com/jwill824/copilot-kit).

## Spec-Kit Workflow

`/speckit.specify` → `/speckit.clarify` → `/speckit.plan` → `/speckit.tasks` → `/speckit.implement` → `/speckit.analyze`

## Project Constitution

See `.specify/memory/constitution.md` for governing principles.

## Stack

See `.specify/memory/stack.md` for tooling and commands.
STUB
  success "Created .github/copilot-instructions.md"
fi
echo ""

# ── Standalone: write project-tooling.json ────────────────────────────────────
echo -e "${BOLD}Step 5: Project tooling declaration${RESET}"
write_project_tooling
echo ""

echo -e "${BOLD}${GREEN}✅  copilot-kit installed!${RESET}\n"
echo -e "  ${BOLD}Next:${RESET} customize ${CYAN}.github/copilot-instructions.md${RESET} for your project"
echo -e "  ${BOLD}Update later:${RESET} ${CYAN}git submodule update --remote .copilot${RESET}\n"
