#!/usr/bin/env bash
# Read-only security status report. Exits nonzero when a required control fails.
set -uo pipefail

failures=0
pass() { printf 'PASS  %s\n' "$1"; }
fail() { printf 'FAIL  %s\n' "$1"; failures=$((failures + 1)); }

case "$(uname -r)" in *-hardened) pass "linux-hardened running" ;; *) fail "linux-hardened not running" ;; esac

root_source="$(findmnt -nro SOURCE /)"
root_device="${root_source%%[*}"
if lsblk -sno TYPE "$root_device" 2>/dev/null | grep -qx crypt; then
  pass "root backed by LUKS"
else
  fail "root is not backed by LUKS"
fi

if mountpoint -q /mnt/Development; then
  development_source="$(findmnt -nro SOURCE /mnt/Development)"
  development_device="${development_source%%[*}"
  if lsblk -sno TYPE "$development_device" 2>/dev/null | grep -qx crypt; then
    pass "Development backed by LUKS"
  else
    fail "Development is not backed by LUKS"
  fi
else
  fail "/mnt/Development is not mounted"
fi

grep -qw apparmor /sys/kernel/security/lsm 2>/dev/null && pass "AppArmor LSM active" || fail "AppArmor LSM inactive"
systemctl is-active --quiet apparmor && pass "AppArmor service active" || fail "AppArmor service inactive"
systemctl is-active --quiet ufw && pass "UFW active" || fail "UFW inactive"
grep -q '^DEFAULT_INPUT_POLICY="DROP"' /etc/default/ufw 2>/dev/null && pass "UFW denies inbound by default" || fail "UFW inbound policy"
systemctl --user is-active --quiet gcr-ssh-agent.socket && pass "GCR SSH socket active" || fail "GCR SSH socket inactive"
[ -S "${SSH_AUTH_SOCK:-}" ] && pass "SSH_AUTH_SOCK valid" || fail "SSH_AUTH_SOCK invalid"

idle_count="$(pgrep -xc hypridle 2>/dev/null || true)"
[ "$idle_count" = 1 ] && pass "one hypridle process" || fail "expected one hypridle process, found $idle_count"

hyprctl getoption ecosystem:enforce_permissions 2>/dev/null | grep -q 'true' && pass "Hyprland permissions enforced" || fail "Hyprland permissions not enforced"
systemctl --failed --no-legend 2>/dev/null | grep -q . && fail "failed system units" || pass "no failed system units"
systemctl --user --failed --no-legend 2>/dev/null | grep -q . && fail "failed user units" || pass "no failed user units"

exit "$failures"
