-- bindings.lua — primary keybinds, Hyprland 0.56.2 Lua API
-- Uses only verified hl.dsp.* helpers: exec_cmd, window.close/float/pseudo/move/drag/resize,
-- focus, workspace.toggle_special, layout, exit.

local mod = "SUPER"

-- Core: terminal / close / launchers (required minimum)
hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd("uwsm app -- alacritty"))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("uwsm app -- unified-launcher"))
hl.bind(mod .. " + SHIFT + SPACE", hl.dsp.exec_cmd("uwsm app -- arch-menu"))

-- Custom UX
hl.bind(mod .. " + P", hl.dsp.exec_cmd("uwsm app -- package-install"))
hl.bind(mod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd("uwsm app -- power-menu"))
hl.bind(mod .. " + L", hl.dsp.exec_cmd("uwsm app -- hyprlock"))
hl.bind(mod .. " + D", hl.dsp.exec_cmd("uwsm app -- monitor-menu"))

-- File manager (keep simple; thunar/nautilus optional — fallback to alacritty)
hl.bind(mod .. " + E", hl.dsp.exec_cmd("uwsm app -- alacritty"))

-- Window management
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
  local key = i % 10
  hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- SwayOSD (volume/brightness) — swayosd-client API, verified after install.
-- Fallback to wpctl/brightnessctl if SwayOSD unavailable; only one path active.
-- These use exec_cmd so they work regardless; duplicates avoided here.
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume +5 || wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume -5 || wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle || wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness +5 || brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness -5 || brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
