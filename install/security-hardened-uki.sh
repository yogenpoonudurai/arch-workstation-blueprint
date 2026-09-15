#!/usr/bin/env bash
# Build a hardened UKI with AppArmor while preserving the standard UKI fallback.
set -euo pipefail

PRESET=/etc/mkinitcpio.d/linux-hardened.preset
BASE_CMDLINE=/etc/kernel/cmdline
HARDENED_CMDLINE=/etc/kernel/cmdline-hardened
HARDENED_UKI=/boot/EFI/Linux/arch-linux-hardened.efi
LSM='lsm=landlock,lockdown,yama,integrity,apparmor,bpf'

die() { printf 'error: %s\n' "$*" >&2; exit 1; }
pacman -Q linux linux-hardened linux-hardened-headers >/dev/null || die "standard and hardened kernels are required"
[ -f "$BASE_CMDLINE" ] || die "$BASE_CMDLINE not found"

sudo -v
sudo test -f /boot/EFI/Linux/arch-linux.efi || die "standard UKI fallback not found"
timestamp="$(date +%Y%m%d-%H%M%S)"
[ ! -f "$PRESET" ] || sudo cp -a "$PRESET" "$PRESET.security-backup-$timestamp"

base="$(sed -E 's/(^|[[:space:]])lsm=[^[:space:]]+//g; s/[[:space:]]+/ /g; s/^ //; s/ $//' "$BASE_CMDLINE")"
printf '%s %s\n' "$base" "$LSM" | sudo tee "$HARDENED_CMDLINE" >/dev/null

sudo tee "$PRESET" >/dev/null <<'EOF'
# Hardened kernel UKI preset managed by dotfiles/install/security-hardened-uki.sh
ALL_kver="/boot/vmlinuz-linux-hardened"
PRESETS=('default')
default_uki="/boot/EFI/Linux/arch-linux-hardened.efi"
default_options="--cmdline /etc/kernel/cmdline-hardened --splash /usr/share/systemd/bootctl/splash-arch.bmp"
EOF

sudo mkinitcpio -p linux-hardened
sudo test -f "$HARDENED_UKI" || die "hardened UKI was not generated"

echo
echo "Hardened UKI generated. Standard UKI remains the fallback."
echo "Inspect: sudo bootctl list"
echo "Test once: sudo bootctl set-default arch-linux.efi"
echo "           sudo bootctl set-oneshot arch-linux-hardened.efi"
echo "           systemctl reboot"
echo "After validation: sudo bootctl set-default arch-linux-hardened.efi"
