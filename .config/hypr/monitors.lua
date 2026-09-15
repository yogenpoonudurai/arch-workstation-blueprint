-- monitors.lua — validated for Hyprland 0.56.2 Lua API
-- Safe fallback: auto-detect single or multi-monitor. Profiles below are
-- applied live via `hyprctl eval` (Super+D display panel).
-- Detected: eDP-1 1920x1200@60 scale 1.5 (laptop panel, Samsung)
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = 1,
})

-- Profiles (uncomment + `hyprctl reload` to persist):
-- Laptop only:
-- hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = "auto" })
-- Extend right (external 1080p right of laptop):
-- hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = "auto" })
-- hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "auto-right", scale = "auto" })
-- Mirror:
-- hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "0x0", scale = "auto", mirror = "eDP-1" })
-- Orientation example (transform: 0 normal, 1 90°, 2 180°, 3 270°):
-- hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = "auto", transform = 0 })
