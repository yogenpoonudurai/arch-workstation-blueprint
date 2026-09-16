## Summary

<!-- What problem does this solve? -->

## Scope and recovery

<!-- Hardware impact, privileged behavior, failure modes, and recovery path. -->

## Validation

- [ ] `bash -n bootstrap.sh install.sh install/*.sh scripts/backup-restic`
- [ ] `git diff --check`
- [ ] `gitleaks git --redact --verbose .`
- [ ] `gitleaks dir --redact --verbose .`
- [ ] Relevant runtime configuration reloaded successfully.
- [ ] Documentation reflects verified behavior and limitations.
- [ ] No secrets, machine identifiers, private addresses, or personal paths added.
