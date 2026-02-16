#!/usr/bin/env bash
# Ansible runner - extracts SSH key from environment, runs playbook
# Prefers NIX_SHELL env var if set, otherwise uses ansible-playbook from PATH
# (direnv automatically provides tools via .envrc nix shell)
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

# Run ansible-playbook - prefer NIX_SHELL if set, otherwise use PATH
if [[ -n "${NIX_SHELL:-}" ]]; then
    nix develop "$NIX_SHELL" --command ansible-playbook "$PLAYBOOK" "$@"
elif command -v ansible-playbook &>/dev/null; then
    ansible-playbook "$PLAYBOOK" "$@"
else
    echo "ERROR: ansible-playbook not found on PATH and NIX_SHELL not set"
    echo "Either activate direnv or set NIX_SHELL to your nix flake path"
    exit 1
fi
