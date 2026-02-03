# Claude Skills

A collection of custom skills, commands, and plugins for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

## Commands

Drop these into `~/.claude/commands/` to use as slash commands in Claude Code.

| Command | Description |
|---------|-------------|
| [`/interview`](commands/interview.md) | Interview you in-depth about a project/feature, then write a detailed spec. Pauses every 5 questions with a confidence score - you decide when to wrap up. |
| [`/ralph-loop`](commands/ralph-loop.md) | Start a Ralph Wiggum loop - continuous self-referential iteration until task completion. Requires the ralph-wiggum plugin. |
| [`/cancel-ralph`](commands/cancel-ralph.md) | Cancel an active Ralph loop. |

## Plugins

### [Ralph Wiggum](plugins/ralph-wiggum/)

Implementation of the [Ralph Wiggum technique](https://ghuntley.com/ralph/) - run Claude in a while-true loop with the same prompt until task completion. Great for TDD workflows, greenfield projects, and any task with clear completion criteria.

**The workflow:**
1. `/interview` to create a detailed spec
2. `/ralph-loop "Implement spec.md. TDD. Output <promise>COMPLETE</promise> when all tests pass." --max-iterations 30`
3. Walk away. Come back to working code.

## Installation

### Commands only

```bash
# Copy individual commands
cp commands/interview.md ~/.claude/commands/
```

### Ralph Wiggum plugin (full)

```bash
# Install plugin
cp -r plugins/ralph-wiggum ~/.claude/plugins/

# Link commands
ln -sf ~/.claude/plugins/ralph-wiggum/commands/ralph-loop.md ~/.claude/commands/ralph-loop.md
ln -sf ~/.claude/plugins/ralph-wiggum/commands/cancel-ralph.md ~/.claude/commands/cancel-ralph.md

# Register the stop hook in ~/.claude/settings.json
# Add to your existing settings:
```

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/plugins/ralph-wiggum/hooks/stop-hook.sh"
          }
        ]
      }
    ]
  }
}
```

## Recipes

### Spec-to-Code (Interview → Ralph Loop)

The most powerful workflow: interview yourself to create a detailed spec, then let Ralph iterate until it's built.

**Step 1: Generate the spec**

```
/interview Build a REST API for managing IoT device configurations
```

Claude interviews you about requirements, edge cases, auth, data models, etc. Every 5 questions it gives a confidence score and asks if you want to continue or wrap up. When done, it writes a detailed `spec.md`.

**Step 2: (Optional) Create a plan**

Review the spec, make edits, then ask Claude to create a `plan.md` with implementation phases.

**Step 3: Ralph Loop**

```
/ralph-loop "Implement the spec in spec.md. Use plan.md as a guideline. TDD. Output <promise>COMPLETE</promise> when all tests pass." --max-iterations 30
```

Claude will:
1. Read the spec and plan
2. Write failing tests first
3. Implement code to make them pass
4. Run tests, see failures, fix them
5. Repeat across iterations (each iteration sees previous work in files)
6. Output `<promise>COMPLETE</promise>` when everything passes

You can walk away and come back to working, tested code.

**Tips:**
- Always use `--max-iterations` as a safety net
- Include "TDD" in the prompt to enforce test-first development
- The spec quality determines the output quality - don't rush the interview
- Check progress anytime: `head -10 .claude/ralph-loop.local.md`

### Quick Bug Fix Loop

```
/ralph-loop "Fix the failing tests in src/. Run pytest after each change. Output <promise>COMPLETE</promise> when all tests pass." --max-iterations 15
```

### Refactoring Loop

```
/ralph-loop "Refactor src/api/ to use dependency injection. Keep all existing tests passing. Add tests for new DI container. Output <promise>COMPLETE</promise> when done and all tests pass." --max-iterations 20
```

## Credits

- **Interview skill**: Adapted from [Danny Postma](https://x.com/dannypostmaa)
- **Ralph Wiggum**: Adapted from [Daisy Hollman](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum) / [Geoffrey Huntley](https://ghuntley.com/ralph/)

## License

MIT
