# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2025-01-12

### Added

- Initial repository structure
- Role: `common` - Base packages and SSH configuration
- Role: `zfs_swap` - ZFS ZVOL swap configuration (96 GB default)
- Role: `kernel_tuning` - Sysctl settings for NVMe and memory management
- Role: `ulimits` - System-wide file descriptor and process limits
- GitHub Actions workflow for ansible-lint
- GitHub Actions workflow for Molecule tests
- Molecule test configuration for role validation
- Renovate configuration for automated dependency updates
- Pre-commit hooks configuration

[Unreleased]: https://github.com/JacobPEvans/ansible-proxmox/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/JacobPEvans/ansible-proxmox/releases/tag/v1.0.0
