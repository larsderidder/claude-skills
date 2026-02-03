---
description: "Start a TDD loop: write tests first, then implement until all pass"
argument-hint: "<feature description>"
allowed-tools: ["Bash(~/.claude/plugins/ralph-wiggum/scripts/setup-ralph-loop.sh:*)"]
hide-from-slash-command-tool: "true"
---

# TDD Loop

A simplified Ralph loop preset for test-driven development.

Execute the setup script with TDD-specific settings:

```!
"$HOME/.claude/plugins/ralph-wiggum/scripts/setup-ralph-loop.sh" "Implement the following feature using strict TDD:

$ARGUMENTS

Process:
1. Write failing tests FIRST (red)
2. Write minimal code to make them pass (green)
3. Refactor if needed
4. Run the full test suite
5. If any tests fail, fix them before moving on
6. Add edge case tests
7. Repeat until comprehensive coverage

Output <promise>COMPLETE</promise> when ALL tests pass and coverage is thorough." --completion-promise "COMPLETE" --max-iterations 20
```

Please follow strict TDD: tests first, then implementation. Do not skip the red-green-refactor cycle.
