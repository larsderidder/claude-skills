---
description: "Pre-deploy sanity check: tests, lint, git status, build"
argument-hint: "[project path]"
allowed-tools: ["Bash(*)", "Read"]
---

# Deploy Check

Run a pre-deployment sanity check on the current project (or specified path).

## Instructions

1. If a path is provided, `cd` to it. Otherwise use the current directory.

2. Run these checks in order, reporting PASS/FAIL for each:

### Git Status
- Working tree clean? (no uncommitted changes)
- On expected branch? (main/master)
- Up to date with remote? (`git fetch --dry-run`)

### Dependencies
- Lock file present and up to date?
- `npm ci` / `pip install` / relevant package manager succeeds?

### Tests
- Detect test runner (pytest, jest, vitest, go test, cargo test, etc.)
- Run full test suite
- Report pass/fail count

### Lint
- Detect linter config (.eslintrc, ruff.toml, .golangci.yml, etc.)
- Run linter
- Report issues

### Build
- Detect build command (package.json scripts, Makefile, Cargo.toml, etc.)
- Run build
- Report success/failure

### Security (quick)
- `npm audit` / `pip audit` / `cargo audit` if available
- Report critical/high vulnerabilities

3. Print summary:
```
Deploy Check: X/Y passed
⚠️  Blockers: [list any FAIL items]
✅ Clear to deploy (if all pass)
```

4. If any check fails, suggest the fix command.
