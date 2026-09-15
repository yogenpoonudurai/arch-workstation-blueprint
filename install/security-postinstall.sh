#!/usr/bin/env bash
# Non-destructive, idempotent security baseline. Disk encryption remains installer-owned.
set -euo pipefail

PAM_LOGIN=/etc/pam.d/login
PAM_AUTH='auth       optional     pam_gnome_keyring.so'
PAM_SESSION='session    optional     pam_gnome_keyring.so auto_start'

die() { printf 'error: %s\n' "$*" >&2; exit 1; }
command -v sudo >/dev/null || die "sudo is required"
command -v ufw >/dev/null || die "ufw is required"
[ -f "$PAM_LOGIN" ] || die "$PAM_LOGIN not found"
for remote_marker in SSH_CONNECTION SSH_CLIENT SSH_TTY MOSH_IP; do
  [ -z "${!remote_marker:-}" ] || die "refusing to change firewall rules inside a remote session; run locally"
done

read -r -p "Type 'enable-firewall' to apply deny-incoming UFW policy: " firewall_approval
[ "$firewall_approval" = enable-firewall ] || die "firewall configuration cancelled"

sudo -v

has_auth=false
has_session=false
sudo grep -Eq '^[[:space:]]*auth[[:space:]]+optional[[:space:]]+pam_gnome_keyring\.so([[:space:]]|$)' "$PAM_LOGIN" && has_auth=true
sudo grep -Eq '^[[:space:]]*session[[:space:]]+optional[[:space:]]+pam_gnome_keyring\.so[[:space:]]+auto_start([[:space:]]|$)' "$PAM_LOGIN" && has_session=true

if [ "$has_auth" = false ] || [ "$has_session" = false ]; then
  sudo cp -a "$PAM_LOGIN" "$PAM_LOGIN.security-backup-$(date +%Y%m%d-%H%M%S)"
fi

if [ "$has_auth" = false ]; then
  printf '%s\n' "$PAM_AUTH" | sudo tee -a "$PAM_LOGIN" >/dev/null
fi

if [ "$has_session" = false ]; then
  printf '%s\n' "$PAM_SESSION" | sudo tee -a "$PAM_LOGIN" >/dev/null
fi

sudo systemctl enable apparmor.service
sudo systemctl enable --now fstrim.timer

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw --force enable
sudo systemctl enable --now ufw.service

systemctl --user enable --now gcr-ssh-agent.socket
# Hyprland autostart owns hypridle so it starts only inside the graphical session.
systemctl --user disable --now hypridle.service 2>/dev/null || true

root_source="$(findmnt -nro SOURCE /)"
root_device="${root_source%%[*}"
if lsblk -sno TYPE "$root_device" 2>/dev/null | grep -qx crypt; then
  echo "root encryption: LUKS detected"
else
  echo "WARNING: root is not backed by a LUKS mapping" >&2
fi

if mountpoint -q /mnt/Development; then
  development_source="$(findmnt -nro SOURCE /mnt/Development)"
  development_device="${development_source%%[*}"
  if lsblk -sno TYPE "$development_device" 2>/dev/null | grep -qx crypt; then
    echo "Development encryption: LUKS detected"
  else
    echo "WARNING: /mnt/Development is not backed by a LUKS mapping" >&2
  fi
fi

echo "security baseline configured; relogin required for PAM/keyring changes"
