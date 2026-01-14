#!/usr/bin/env bash
# Ansible runner with Doppler secrets integration
# Extracts SSH key from Doppler to temp file, runs playbook, cleans up

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

# Extract SSH key from Doppler and write to temp file
# Doppler must have: PVE_SSH_PRIVATE_KEY, PVE_HOST, PVE_USER
doppler run --command "echo \"\$PVE_SSH_PRIVATE_KEY\"" > "$SSH_KEY_FILE"

# Run ansible-playbook with Doppler environment
export ANSIBLE_PRIVATE_KEY_FILE="$SSH_KEY_FILE"
doppler run -- ansible-playbook "$PLAYBOOK" "$@"
