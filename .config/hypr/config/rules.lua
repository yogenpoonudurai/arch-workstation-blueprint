-- rules.lua — predictable floating, sane dialogs, correct fullscreen.
-- Validated for Hyprland 0.56.2 Lua API.

-- Ignore maximize requests from apps (verified example rule)
hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

-- Fix dragging issues with XWayland (verified example rule)
hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})

-- Float + center + dim around small utility dialogs
hl.window_rule({
  name = "float-utility-dialogs",
  match = { class = "pavucontrol|blueman-manager|nwg-look|gsimplecal|file-roller|loupe" },
  float = true,
  center = true,
  dim_around = true,
})

-- File managers / browsers stay tiled by default; dialogs float
hl.window_rule({
  name = "nautilus-float-progress",
  match = { class = "org.gnome.Nautilus", title = ".*Progress.*|.*Copy.*|.*Move.*" },
  float = true,
  center = true,
})

-- Picture-in-picture / media float
hl.window_rule({
  name = "pip-float",
  match = { title = ".*Picture-in-Picture.*|.*Picture in picture.*" },
  float = true,
  pin = true,
})
