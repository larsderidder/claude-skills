#!/bin/bash
# gated-exec: Run a command with secrets from /etc/agent-secrets/
# Requires polkit authentication (interactive password/fingerprint prompt)
#
# Usage: gated-exec <profile> <command> [args...]
#   profile: name of the secrets file in /etc/agent-secrets/
#   command: the command to run
#   args:    arguments passed to the command
#
# Example: gated-exec bird bird post "Hello world"

set -euo pipefail

if [[ $# -lt 2 ]]; then
    echo "Usage: gated-exec <profile> <command> [args...]" >&2
    echo "" >&2
    echo "Profiles available:" >&2
    pkexec --disable-internal-agent ls /etc/agent-secrets/ 2>/dev/null || echo "  (authenticate to see)" >&2
    exit 1
fi

PROFILE="$1"
shift

# Show the user exactly what's being attempted via desktop notification
COMMAND_PREVIEW="$*"
# Truncate long commands for readability
if [[ ${#COMMAND_PREVIEW} -gt 200 ]]; then
    COMMAND_PREVIEW="${COMMAND_PREVIEW:0:200}..."
fi

# Send desktop notification so user sees what's happening
notify-send --urgency=critical \
    --icon=dialog-password \
    "🔐 Agent Requesting Access" \
    "Profile: $PROFILE\nCommand: $COMMAND_PREVIEW" \
    2>/dev/null || true

# pkexec runs the helper as root, which can then read the secrets
# The message field in the polkit policy shows in the auth dialog,
# but we pass the full command as env so the helper can log it
GATED_EXEC_COMMAND="$COMMAND_PREVIEW" \
pkexec /usr/local/bin/gated-exec-helper "$PROFILE" "$@"
