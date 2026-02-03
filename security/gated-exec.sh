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

# pkexec runs the helper as root, which can then read the secrets
# The user must authenticate via polkit (password/fingerprint/hardware key)
pkexec /usr/local/bin/gated-exec-helper "$PROFILE" "$@"
