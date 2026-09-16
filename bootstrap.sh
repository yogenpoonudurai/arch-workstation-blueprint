#!/usr/bin/env bash
# bootstrap.sh — fresh Arch PC provisioner. Idempotent, re-runnable.
# Usage (on new PC after archinstall):
#   git clone https://github.com/yogenpoonudurai/arch-workstation-blueprint.git ~/dotfiles
#   ~/dotfiles/bootstrap.sh
set -euo pipefail

DOT="${DOTFILES:-$HOME/dotfiles}"
PKG="$DOT/packages"

die() { echo "ERR: $*" >&2; exit 1; }
[ -f /etc/arch-release ] || die "Arch Linux required"
command -v sudo >/dev/null || die "sudo required"

install_microcode() {
  local vendor
  vendor="$(LC_ALL=C lscpu | awk -F: '/^Vendor ID:/ { gsub(/^[[:space:]]+/, "", $2); print $2 }')"
  case "$vendor" in
    AuthenticAMD) sudo pacman -S --needed --noconfirm amd-ucode ;;
    GenuineIntel) sudo pacman -S --needed --noconfirm intel-ucode ;;
    *) echo "WARNING: unknown CPU vendor '$vendor'; install the correct microcode manually" >&2 ;;
  esac
}

# Optional: clone dotfiles when a repository URL is provided
if [ ! -d "$DOT" ]; then
  [ -n "${DOTFILES_REPO:-}" ] || die "no ~/dotfiles; set DOTFILES_REPO=<url> or clone manually"
  git clone "$DOTFILES_REPO" "$DOT"
fi

echo "==> sudo keep-alive"
sudo -v

echo "==> repo packages ($(grep -cE '^[^#[:space:]]' "$PKG/pacman.txt") entries)"
grep -vE '^\s*(#|$)' "$PKG/pacman.txt" | sudo pacman -S --needed --noconfirm -

echo "==> CPU microcode"
install_microcode

echo "==> AUR packages are intentionally not automated"
echo "Audit each PKGBUILD and install manually:"
grep -vE '^\s*(#|$)' "$PKG/aur.txt" || true

echo "==> dotfiles symlinks"
"$DOT/install.sh"

echo "==> Rust toolchain"
rustup default stable 2>/dev/null || true
rustup component add rust-analyzer 2>/dev/null || true

echo "==> Go tools"
while read -r mod; do
  [[ "$mod" =~ ^\s*(#|$) ]] && continue
  go install "$mod"
done < "$PKG/go.txt"

echo "==> pnpm globals are intentionally not automated"
echo "Audit package metadata, lifecycle scripts, and dependencies before installing:"
grep -vE '^\s*(#|$)' "$PKG/pnpm.txt" || true

echo "==> cargo tools"
while read -r c; do
  [[ "$c" =~ ^\s*(#|$) ]] && continue
  cargo install "$c"
done < "$PKG/cargo.txt"

echo "==> services (no auth tokens baked in)"
sudo systemctl enable --now NetworkManager bluetooth power-profiles-daemon tailscaled

echo "==> security baseline"
"$DOT/install/security-postinstall.sh"

echo
echo "MANUAL (need your password/session, not scripted):"
echo "  1. sudo sh -c 'grep -qxF /usr/bin/zsh /etc/shells || echo /usr/bin/zsh >> /etc/shells'; chsh -s /usr/bin/zsh"
echo "  2. audit/install packages/aur.txt (never automated)"
echo "  3. audit/install packages/pnpm.txt (never automated)"
echo "  4. sudo tailscale up   (interactive auth, never in scripts)"
echo "  5. verify the standard UKI boots, then install/security-hardened-uki.sh"
echo "  6. one-shot test the hardened UKI before changing the default"
echo "  7. reboot; SUPER+Enter → zsh; noctalia bar should appear"
echo "  8. sudo -v && install/security-verify.sh"
