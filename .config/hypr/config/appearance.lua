-- appearance.lua — restrained polish, OLED-friendly, Hyprland 0.56.2 API
-- Requires config.theme before this file (see hyprland.lua).
-- Visual language: radius 12, gaps 6/10, border 2, subtle blur, soft shadow.

hl.config({
  general = {
    gaps_in = 6,
    gaps_out = 10,
    border_size = 2,
    col = {
      active_border = { colors = { Theme.active1, Theme.active2 }, angle = 45 },
      inactive_border = Theme.inactive,
    },
    resize_on_border = false,
    allow_tearing = false,
    layout = "dwindle",
  },
  decoration = {
    rounding = 12,
    rounding_power = 2,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = 0xee1a1a1a,
    },
    blur = {
      enabled = true,
      size = 5,
      passes = 2,
      vibrancy = 0.1696,
    },
  },
  dwindle = {
    preserve_split = true,
  },
  master = {
    new_status = "master",
  },
  misc = {
    force_default_wallpaper = -1,
    disable_hyprland_logo = false,
  },
})
