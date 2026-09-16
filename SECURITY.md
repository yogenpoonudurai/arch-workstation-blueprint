# Security policy

## Supported version

Security fixes target the current `main` branch. This is a personal workstation
blueprint, not a supported Linux distribution.

## Reporting a vulnerability

Do not open a public issue for a vulnerability that could expose secrets,
escalate privileges, weaken boot or firewall recovery, inject commands, or
produce a false-success backup.

Use GitHub's private vulnerability reporting for this repository. Include:

- The affected file and line.
- Preconditions and realistic impact.
- Minimal reproduction steps.
- A suggested mitigation, if known.

Do not include real credentials, keys, tokens, or personal infrastructure data.

Configuration mistakes, compatibility problems, and non-exploitable failures
may be reported through normal public issues.

## Scope

High-interest areas include privileged shell execution, PAM changes, UFW
policy, UKI generation and fallback, secret handling, symlink installation,
and Restic backup completeness.
