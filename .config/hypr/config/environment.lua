-- environment.lua — Wayland session env, OLED-safe cursor.
-- Requires Hyprland restart for some vars (not just reload).

hl.env("XCURSOR_SIZE", "28")
hl.env("HYPRCURSOR_SIZE", "28")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")

-- Permissions (require Hyprland restart, not reload)
hl.config({
	ecosystem = {
		enforce_permissions = true,
	},
})

hl.permission("/usr/bin/grim", "screencopy", "allow")
hl.permission("/usr/bin/noctalia", "screencopy", "allow")
hl.permission("/usr/lib/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- GNOME Keyring / SSH agent integration (works with uwsm + PAM)
local runtime_dir = assert(os.getenv("XDG_RUNTIME_DIR"), "XDG_RUNTIME_DIR is required")
hl.env("SSH_AUTH_SOCK", runtime_dir .. "/gcr/ssh")
