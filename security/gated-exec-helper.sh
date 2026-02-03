#!/bin/bash
# gated-exec-helper: Runs as root via pkexec, loads secrets, drops privileges, executes command
# This file should be installed at /usr/local/bin/gated-exec-helper

set -euo pipefail

SECRETS_DIR="/etc/agent-secrets"
EXEC_USER="${GATED_EXEC_USER:-lars}"  # User to drop privileges to

if [[ $# -lt 2 ]]; then
    echo "Usage: gated-exec-helper <profile> <command> [args...]" >&2
    exit 1
fi

PROFILE="$1"
shift

SECRETS_FILE="$SECRETS_DIR/$PROFILE"

if [[ ! -f "$SECRETS_FILE" ]]; then
    echo "Error: secrets profile '$PROFILE' not found" >&2
    exit 1
fi

# Validate profile name (prevent path traversal)
if [[ "$PROFILE" == *"/"* ]] || [[ "$PROFILE" == *".."* ]]; then
    echo "Error: invalid profile name" >&2
    exit 1
fi

# Load secrets as environment variables
set -a
source "$SECRETS_FILE"
set +a

# Drop privileges back to the original user and run the command
exec sudo -u "$EXEC_USER" --preserve-env "$@"
