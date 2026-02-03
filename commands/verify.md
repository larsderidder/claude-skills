---
description: "Verify a release after publishing (npm, PyPI, or ClawHub)"
argument-hint: "<type> <package> <version> [options]"
allowed-tools: ["Bash(*)", "Read"]
---

# Verify Release

Run a post-publish smoke test to confirm your package is live and installable.

## Instructions

Parse the arguments:
- `type`: `npm`, `pypi`, or `clawhub`
- `package`: package name
- `version`: expected version
- `options`: optional flags (see below)

Then run the appropriate verification:

### npm
```bash
TMPDIR=$(mktemp -d)
cd "$TMPDIR"
npm view $PACKAGE version  # Should match expected
npm install $PACKAGE       # Should succeed
# If --bin flag: npx $BIN --help
rm -rf "$TMPDIR"
```

### PyPI
```bash
TMPDIR=$(mktemp -d)
python -m venv "$TMPDIR/venv"
source "$TMPDIR/venv/bin/activate"
pip install $PACKAGE==$VERSION   # Should succeed
# If --import flag: python -c "import $MODULE"
# If --bin flag: $BIN --help
deactivate
rm -rf "$TMPDIR"
```

### ClawHub
```bash
TMPDIR=$(mktemp -d)
cd "$TMPDIR"
openclaw skill search $PACKAGE   # Should find it
openclaw skill inspect $PACKAGE  # Should show expected version
openclaw skill install $PACKAGE  # Should succeed
rm -rf "$TMPDIR"
```

## Output

For each check, print:
- ✅ PASS or ❌ FAIL with the command that was run
- If FAIL: most likely cause and how to fix

End with a summary: `X/Y checks passed`
