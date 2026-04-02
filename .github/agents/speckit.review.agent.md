---
description: Perform a structured code review of the current branch changes before opening a PR.
handoffs:
  - label: Re-implement fixes
    agent: speckit.implement
    prompt: Implement the fixes identified in the review
  - label: Run analysis
    agent: speckit.analyze
    prompt: Analyze the changes for quality and spec compliance
---

# /speckit.review

Perform a thorough, structured code review of all changes on the current branch before opening a pull request.

## Step 1: Load Context

Read the project constitution and stack reference:
- `.specify/memory/constitution.md` — core principles and governance
- `.specify/memory/stack.md` — technology stack, lint/test commands

## Step 2: Understand Scope

Run `git diff main...HEAD --stat` to get a high-level summary of what changed (files, insertions, deletions).

## Step 3: Read All Changes

Run `git diff main...HEAD` to read the full diff. Take note of:
- What problem this change is solving
- Which modules, files, and layers are affected

## Step 4: Check Constitution Compliance

Review each change against the core principles in `constitution.md`. Any violation of a NON-NEGOTIABLE principle is a **CRITICAL** finding.

## Step 5: Check for Common Issues

Flag the following if found:

- **Missing tests** — new logic without corresponding tests
- **Hardcoded secrets or credentials** — any API keys, tokens, passwords in code
- **TODO/FIXME comments** left in production code
- **Dead code** — unreachable branches, unused variables/imports
- **Debug statements** — `console.log`, `print`, `debugger`, etc. that shouldn't ship

## Step 6: Run Lint and Tests

Check `.specify/memory/stack.md` for the lint and test commands, then run them. Report pass/fail.

## Step 7: Produce Structured Review Report

Output a review report with findings organized by severity:

```
## Review Report

### CRITICAL
> Violations of NON-NEGOTIABLE constitution principles. Must be resolved before merge.

### HIGH
> Hardcoded secrets, missing tests for new public APIs, broken lint/tests.

### MEDIUM
> TODO/FIXME left in code, dead code, debug statements.

### LOW
> Minor style issues, suggestions for improvement.

### Summary
> Overall assessment and recommended next step.
```

## Step 8: Resolve Critical Issues

If there are any **CRITICAL** findings, ask the user to resolve them before proceeding. Offer to hand off to `/speckit.implement` to fix them.

## Step 9: If Clean, Suggest Next Steps

If no CRITICAL or HIGH issues are found, congratulate the user and suggest:
1. Using the `conventional-commit` skill to write a great commit message
2. Opening a pull request
