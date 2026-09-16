#!/usr/bin/env bash
# Read-only security status report. Exits nonzero when a required control fails.
set -uo pipefail

failures=0
DEVELOPMENT_PATH="${DEVELOPMENT_PATH:-/mnt/Development}"
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

if mountpoint -q "$DEVELOPMENT_PATH"; then
  development_source="$(findmnt -nro SOURCE "$DEVELOPMENT_PATH")"
  development_device="${development_source%%[*}"
  if lsblk -sno TYPE "$development_device" 2>/dev/null | grep -qx crypt; then
    pass "$DEVELOPMENT_PATH backed by LUKS"
  else
    fail "$DEVELOPMENT_PATH is not backed by LUKS"
  fi
else
  fail "$DEVELOPMENT_PATH is not mounted"
fi

grep -qw apparmor /sys/kernel/security/lsm 2>/dev/null && pass "AppArmor LSM active" || fail "AppArmor LSM inactive"
systemctl is-active --quiet apparmor && pass "AppArmor service active" || fail "AppArmor service inactive"
ufw_status=""
ufw_status_ok=false
if [ "${EUID:-$(id -u)}" -eq 0 ]; then
  if ufw_status="$(LC_ALL=C ufw status verbose 2>/dev/null)" && [ -n "$ufw_status" ]; then
    ufw_status_ok=true
  else
    fail "UFW live status command failed"
  fi
elif sudo -n true 2>/dev/null; then
  if ufw_status="$(sudo -n env LC_ALL=C ufw status verbose 2>/dev/null)" && [ -n "$ufw_status" ]; then
    ufw_status_ok=true
  else
    fail "UFW live status command failed"
  fi
else
  fail "UFW live status unavailable; run sudo -v before verification"
fi

if [ "$ufw_status_ok" = true ]; then
  printf '%s\n' "$ufw_status" | grep -q '^Status: active' && pass "UFW live rules active" || fail "UFW live rules inactive"
  printf '%s\n' "$ufw_status" | grep -q 'Default: deny (incoming)' && pass "UFW live policy denies inbound" || fail "UFW live inbound policy"
fi
systemctl --user is-active --quiet gcr-ssh-agent.socket && pass "GCR SSH socket active" || fail "GCR SSH socket inactive"
[ -S "${SSH_AUTH_SOCK:-}" ] && pass "SSH_AUTH_SOCK valid" || fail "SSH_AUTH_SOCK invalid"

idle_count="$(pgrep -xc hypridle 2>/dev/null || true)"
[ "$idle_count" = 1 ] && pass "one hypridle process" || fail "expected one hypridle process, found $idle_count"

hyprctl getoption ecosystem:enforce_permissions 2>/dev/null | grep -q 'true' && pass "Hyprland permissions enforced" || fail "Hyprland permissions not enforced"
systemctl --failed --no-legend 2>/dev/null | grep -q . && fail "failed system units" || pass "no failed system units"
systemctl --user --failed --no-legend 2>/dev/null | grep -q . && fail "failed user units" || pass "no failed user units"

exit "$failures"
