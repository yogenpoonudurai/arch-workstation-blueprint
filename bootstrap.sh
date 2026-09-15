#!/usr/bin/env bash
# bootstrap.sh — fresh Arch PC provisioner. Idempotent, re-runnable.
# Usage (on new PC after archinstall):
#   git clone <your-dotfiles-remote> ~/dotfiles && ~/dotfiles/bootstrap.sh
set -euo pipefail

DOT="${DOTFILES:-$HOME/dotfiles}"
PKG="$DOT/packages"

die() { echo "ERR: $*" >&2; exit 1; }
[ -f /etc/arch-release ] || die "Arch Linux required"
command -v sudo >/dev/null || die "sudo required"

# Optional: clone dotfiles when a repository URL is provided
if [ ! -d "$DOT" ]; then
  [ -n "${DOTFILES_REPO:-}" ] || die "no ~/dotfiles; set DOTFILES_REPO=<url> or clone manually"
  git clone "$DOTFILES_REPO" "$DOT"
fi

echo "==> sudo keep-alive"
sudo -v

echo "==> repo packages ($(grep -cE '^[^#[:space:]]' "$PKG/pacman.txt") entries)"
grep -vE '^\s*(#|$)' "$PKG/pacman.txt" | sudo pacman -S --needed --noconfirm -

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

echo "==> pnpm globals"
export PATH="$HOME/.local/share/pnpm/bin:$PATH"
while read -r p; do
  [[ "$p" =~ ^\s*(#|$) ]] && continue
  pnpm add -g "$p"
done < "$PKG/pnpm.txt"

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
echo "  3. sudo tailscale up   (interactive auth, never in scripts)"
echo "  4. install/security-hardened-uki.sh; one-shot test before changing the default"
echo "  5. reboot; SUPER+Enter → zsh; noctalia bar should appear"
echo "  6. install/security-verify.sh"
