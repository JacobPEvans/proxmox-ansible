#!/usr/bin/env bash
# Ansible runner - extracts SSH key from environment, runs playbook via Nix shell
# See local SECRETS_SETUP.md for environment configuration

set -euo pipefail

NIX_SHELL="${NIX_SHELL:-}"

if [[ -z "$NIX_SHELL" ]]; then
    echo "ERROR: NIX_SHELL environment variable must be set"
    echo "Example: export NIX_SHELL=~/git/nix-config/main/shells/infrastructure-automation"
    exit 1
fi

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

# Run ansible-playbook via Nix shell
export ANSIBLE_PRIVATE_KEY_FILE="$SSH_KEY_FILE"
nix develop "$NIX_SHELL" --command ansible-playbook "$PLAYBOOK" "$@"
