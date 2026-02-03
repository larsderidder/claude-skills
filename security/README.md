# Agent Credential Isolation

A pattern for preventing AI agents from bypassing approval gates for sensitive operations.

## The Problem

If your AI agent runs as your user, it can:
- Read your browser cookies and call APIs directly
- Bypass any "wrapper script" by calling the underlying tool or API
- Access any file you can access

Software wrappers are security theater. The agent can always `curl` around them.

## The Solution: OS-Level Isolation

Use Unix permissions to ensure the agent **never sees the credentials**. A separate user holds the secrets, and a polkit-gated helper requires interactive authentication (password/fingerprint/hardware key) before executing.

```
┌─────────────────┐     polkit auth      ┌──────────────────┐
│  Agent (you)     │ ──── password ────→  │  gated-exec      │
│  No credentials  │     required         │  (reads secrets)  │
│  Can't bypass    │                      │  Runs the command │
└─────────────────┘                      └──────────────────┘
```

## Setup

### 1. Create a secrets user

```bash
sudo useradd -r -s /usr/sbin/nologin agent-secrets
sudo mkdir -p /etc/agent-secrets
sudo chown agent-secrets:agent-secrets /etc/agent-secrets
sudo chmod 700 /etc/agent-secrets
```

### 2. Store credentials

```bash
# Example: store bird (X/Twitter) auth tokens
sudo -u agent-secrets tee /etc/agent-secrets/bird-env > /dev/null << 'EOF'
BIRD_AUTH_TOKEN=your_auth_token_here
BIRD_CT0=your_ct0_token_here
EOF
sudo chmod 600 /etc/agent-secrets/bird-env
```

### 3. Install the gated executor

```bash
sudo cp gated-exec.sh /usr/local/bin/gated-exec
sudo chmod 755 /usr/local/bin/gated-exec
sudo cp gated-exec.policy /usr/share/polkit-1/actions/
```

### 4. Use it

```bash
# This will pop a password/fingerprint dialog
gated-exec bird post "Hello from a secured agent"

# The agent sees this:
# → polkit dialog appears
# → human authenticates
# → command runs with credentials loaded
# → agent never sees the tokens
```

## What this protects against

| Attack | Blocked? |
|--------|----------|
| Agent calls `bird post` directly | ✅ No credentials in env/config |
| Agent uses `curl` to hit X API | ✅ Doesn't know the tokens |
| Agent reads Chrome cookies | ⚠️ Needs separate browser profile or cookie encryption |
| Agent reads `/etc/agent-secrets/` | ✅ Wrong user, permission denied |
| Agent uses `sudo` | ✅ Requires password (agent doesn't know it) |

## Chrome Cookie Problem

Bird extracts cookies from Chrome's cookie DB (`~/.config/google-chrome/Default/Cookies`). Since the agent runs as the same user, it could theoretically read these directly.

Options:
1. **Separate Chrome profile** for X login, owned by `agent-secrets` user
2. **Extract and store tokens** in `/etc/agent-secrets/` and use `--auth-token`/`--ct0` flags instead of cookie extraction
3. **Run the agent as a different user** entirely (strongest isolation)

Option 2 is the most practical: extract your X cookies once, store them in the secrets vault, and always use explicit token flags through the gated executor.

## Extending to other tools

The same pattern works for any sensitive operation:
- Email sending (SMTP credentials)
- Social media posting (API keys)
- Cloud deployments (AWS/GCP credentials)
- Financial APIs
- Anything you want human-in-the-loop approval for

Just add the credentials to `/etc/agent-secrets/` and create a gated-exec command for each tool.
