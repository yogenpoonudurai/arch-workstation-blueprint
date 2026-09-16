# Contributing

Contributions should make this blueprint safer, clearer, or easier to adapt
without weakening the tested recovery path.

## Good contributions

- Portability fixes that preserve the Zenbook profile.
- Additional hardware profiles kept separate from global defaults.
- Reproducible bug fixes with validation output.
- Recovery, backup, and failure-mode improvements.
- Documentation that distinguishes verified state from recommendations.

Avoid unrelated preference churn, automated AUR installation, destructive disk
operations, embedded credentials, and claims that cannot be reproduced.

## Workflow

1. Fork the repository and create a focused branch.
2. Explain the problem, hardware impact, and recovery behavior.
3. Keep privileged changes minimal and idempotent.
4. Update documentation with behavior changes.
5. Run the checks below.
6. Open a pull request using the repository template.

## Required checks

```bash
bash -n bootstrap.sh install.sh install/*.sh scripts/backup-restic
git diff --check
gitleaks git --redact --verbose .
gitleaks dir --redact --verbose .
```

For Hyprland changes, reload the configuration and report any errors. For
security changes, run `install/security-verify.sh` and explain all failures.

## Security and privacy

Never commit:

- Passwords, tokens, authentication cookies, or private keys.
- Restic passwords, Secure Boot keys, or LUKS recovery material.
- Terraform state or variable files from a real environment.
- Hostnames, public IP addresses, Tailnet addresses, machine IDs, or serials.
- Generated backups of PAM, boot, or security configuration.

Use placeholders and `.example` files for documentation.

Report vulnerabilities privately as described in [SECURITY.md](SECURITY.md).
