#!/usr/bin/env bash
# Ansible runner - extracts SSH key from environment, runs playbook
# When direnv is active, tools are on PATH via .envrc (nix shell auto-loaded)
# Without direnv, set NIX_SHELL to the nix shell path for explicit activation
set -euo pipefail

usage() {
    echo "Usage: $0 <playbook> [ansible-playbook args...]"
    echo "Example: $0 playbooks/monitoring.yml --check"
    exit 1
}

[[ $# -lt 1 ]] && usage

PLAYBOOK="$1"
shift

# Create temp file for SSH key with secure permissions
SSH_KEY_FILE=$(mktemp)
chmod 600 "$SSH_KEY_FILE"

cleanup() {
    rm -f "$SSH_KEY_FILE"
}
trap cleanup EXIT

# Write SSH key from environment to temp file
echo "$PROXMOX_SSH_PRIVATE_KEY" > "$SSH_KEY_FILE"
export ANSIBLE_PRIVATE_KEY_FILE="$SSH_KEY_FILE"

# Run ansible-playbook - direnv provides tools on PATH, or use nix develop fallback
if command -v ansible-playbook &>/dev/null; then
    ansible-playbook "$PLAYBOOK" "$@"
elif [[ -n "${NIX_SHELL:-}" ]]; then
    nix develop "$NIX_SHELL" --command ansible-playbook "$PLAYBOOK" "$@"
else
    echo "ERROR: ansible-playbook not found on PATH and NIX_SHELL not set"
    echo "Either activate direnv or set NIX_SHELL=~/git/nix-config/main/shells/infrastructure-automation"
    exit 1
fi
