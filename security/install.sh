#!/bin/bash
# Install gated-exec credential isolation
# Run with: sudo bash install.sh

set -euo pipefail

echo "=== Agent Credential Isolation Setup ==="

# Create secrets user
if ! id agent-secrets &>/dev/null; then
    useradd -r -s /usr/sbin/nologin agent-secrets
    echo "✅ Created agent-secrets user"
else
    echo "✅ agent-secrets user exists"
fi

# Create secrets directory
mkdir -p /etc/agent-secrets
chown agent-secrets:agent-secrets /etc/agent-secrets
chmod 700 /etc/agent-secrets
echo "✅ /etc/agent-secrets/ ready"

# Install helper
cp gated-exec-helper.sh /usr/local/bin/gated-exec-helper
chmod 755 /usr/local/bin/gated-exec-helper
echo "✅ Installed gated-exec-helper"

# Install user-facing command
cp gated-exec.sh /usr/local/bin/gated-exec
chmod 755 /usr/local/bin/gated-exec
echo "✅ Installed gated-exec"

# Install polkit policy
cp com.agent.gated-exec.policy /usr/share/polkit-1/actions/
echo "✅ Installed polkit policy"

echo ""
echo "=== Done! ==="
echo ""
echo "Next steps:"
echo "  1. Add credentials:  sudo tee /etc/agent-secrets/bird <<< 'BIRD_AUTH_TOKEN=xxx'"
echo "  2. Secure them:      sudo chown agent-secrets:agent-secrets /etc/agent-secrets/bird && sudo chmod 600 /etc/agent-secrets/bird"
echo "  3. Test:              gated-exec bird bird post 'test'"
echo ""
echo "The agent can call 'gated-exec bird bird post ...' but will get a"
echo "password prompt on your desktop. No password = no post."
