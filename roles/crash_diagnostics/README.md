# Crash Diagnostics Role

Configures kernel crash diagnostics for Proxmox VE systems.

## What It Does

1. **Installs debugging packages**: kdump-tools, crash, strace, tcpdump, rasdaemon, etc.
2. **Configures sysctl settings**: Kernel panic behavior, watchdogs, logging verbosity
3. **Configures GRUB parameters**: Boot-time panic settings via drop-in config

## Requirements

- Proxmox VE (Debian-based)
- Ansible 2.15+

## Usage

```bash
ansible-playbook -i inventory/hosts.yml playbooks/crash_diagnostics.yml
```

## Important Notes

- **Reboot required**: GRUB changes only take effect after reboot
- **Uses drop-in configs**: Safe for Proxmox upgrades (`/etc/default/grub.d/`, `/etc/sysctl.d/`)
- **Removes old configs**: Cleans up `/etc/sysctl.d/99-debug.conf` if present

## Variables

See `defaults/main.yml` for all configurable options:

- `crash_diagnostics_packages` - List of packages to install
- `crash_diagnostics_sysctl_settings` - Kernel parameters
- `crash_diagnostics_grub_params` - Boot-time kernel parameters

## Tags

- `crash_diagnostics` - All tasks
- `packages` - Package installation only
- `sysctl` - Sysctl configuration only
- `grub` - GRUB configuration only
