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

## Credits

- **Interview skill**: Adapted from [Danny Postma](https://x.com/dannypostmaa)
- **Ralph Wiggum**: Adapted from [Daisy Hollman](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum) / [Geoffrey Huntley](https://ghuntley.com/ralph/)

## License

MIT
