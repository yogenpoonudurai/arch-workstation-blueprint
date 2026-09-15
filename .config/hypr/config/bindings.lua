-- bindings.lua — keyboard-first, emergency-safe. Hyprland 0.56.2 Lua API.
-- Emergency: SUPER+Enter must always open terminal even if shell fails.
-- Uses verified hl.dsp.* + exec_cmd fallbacks for fullscreen/screenshots.

local mod = "SUPER"

-- Core (recovery-safe)
hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd("uwsm app -- alacritty"))
hl.bind(mod .. " + ALT + RETURN", hl.dsp.exec_cmd("uwsm app -- alacritty -e tmux new-session -A -s main"))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + W", hl.dsp.window.close())
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
hl.bind(mod .. " + SHIFT + SPACE", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher /emo || noctalia msg panel-toggle launcher"))

-- Spec: SUPER+M → power/exit UI
-- Interim focus mode on Super+F (true fullscreen unreachable on 0.56.2:
-- hyprctl dispatch mangles args, no hl.dsp fullscreen object, hl.window nil).
-- Workspace 10 is the focus room (Super+0 also lands there).
local FOCUS_WS = 10
local focus_home = nil
hl.bind(mod .. " + F", function()
  local ws = hl.get_active_workspace()
  local cur = ws and ws.id or nil
  if focus_home ~= nil and tostring(cur) == tostring(FOCUS_WS) then
    local home = focus_home
    focus_home = nil
    hl.dispatch(hl.dsp.window.move({ workspace = home }))
    hl.dispatch(hl.dsp.focus({ workspace = home }))
  else
    focus_home = cur
    hl.dispatch(hl.dsp.window.move({ workspace = FOCUS_WS }))
    hl.dispatch(hl.dsp.focus({ workspace = FOCUS_WS }))
  end
end)
hl.bind(mod .. " + M", hl.dsp.exec_cmd("noctalia msg panel-toggle session || noctalia msg panel-toggle control-center"))
hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd("noctalia msg panel-toggle session"))
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))

-- Window tiling
hl.bind(mod .. " + T", hl.dsp.layout("togglesplit"))

-- Launcher / tools (pacseek preferred, Noctalia panels for shell UI)
hl.bind(mod .. " + P", hl.dsp.exec_cmd("uwsm app -- /home/yp/.local/bin/package-install"))
hl.bind(mod .. " + B", hl.dsp.exec_cmd("uwsm app -- brave 2>/dev/null || uwsm app -- chromium"))
hl.bind(mod .. " + N", hl.dsp.exec_cmd("noctalia msg panel-toggle notifications 2>/dev/null || noctalia msg notification-invoke-latest"))
hl.bind(mod .. " + SHIFT + N", hl.dsp.exec_cmd("noctalia msg notification-clear-active"))
hl.bind(mod .. " + SHIFT + O", hl.dsp.exec_cmd("uwsm app -- hyprlock"))
hl.bind(mod .. " + D", hl.dsp.exec_cmd("uwsm app -- /home/yp/.local/bin/monitor-ctl"))
hl.bind(mod .. " + E", hl.dsp.exec_cmd("uwsm app -- nautilus 2>/dev/null || uwsm app -- alacritty"))
hl.bind(mod .. " + C", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center"))
hl.bind(mod .. " + SHIFT + C", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))

-- Focus: arrows + HJKL
hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Move window: SHIFT + arrows/HJKL (exec fallback avoids API guess)
hl.bind(mod .. " + SHIFT + left", hl.dsp.exec_cmd("hyprctl dispatch movewindow l"))
hl.bind(mod .. " + SHIFT + right", hl.dsp.exec_cmd("hyprctl dispatch movewindow r"))
hl.bind(mod .. " + SHIFT + up", hl.dsp.exec_cmd("hyprctl dispatch movewindow u"))
hl.bind(mod .. " + SHIFT + down", hl.dsp.exec_cmd("hyprctl dispatch movewindow d"))
hl.bind(mod .. " + SHIFT + H", hl.dsp.exec_cmd("hyprctl dispatch movewindow l"))
hl.bind(mod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprctl dispatch movewindow r"))
hl.bind(mod .. " + SHIFT + K", hl.dsp.exec_cmd("hyprctl dispatch movewindow u"))
hl.bind(mod .. " + SHIFT + J", hl.dsp.exec_cmd("hyprctl dispatch movewindow d"))

-- Workspaces 1-9 + move
for i = 1, 9 do
  hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
-- Keep 10/0 for completeness
hl.bind(mod .. " + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind(mod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Screenshots: Noctalia IPC preferred (annotate/save/copy), grim fallback
hl.bind("Print", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen 2>/dev/null || (mkdir -p ~/Pictures/Screenshots && grim ~/Pictures/Screenshots/$(date +%Y%m%d-%H%M%S).png && wl-copy < $(ls -t ~/Pictures/Screenshots/*.png | head -n1)) || true"), { locked = true })
hl.bind(mod .. " + Print", hl.dsp.exec_cmd("noctalia msg screenshot-region 2>/dev/null || (mkdir -p ~/Pictures/Screenshots && grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +%Y%m%d-%H%M%S).png && wl-copy < $(ls -t ~/Pictures/Screenshots/*.png | head -n1)) || true"), { locked = true })
hl.bind(mod .. " + SHIFT + Print", hl.dsp.exec_cmd("mkdir -p ~/Pictures/Screenshots && grim -g \"$(hyprctl activewindow -j | jq -r '.at,.size | join(\" \")' | awk '{print $1\",\"$2\" \"$3\"x\"$4}')\" ~/Pictures/Screenshots/$(date +%Y%m%d-%H%M%S).png 2>/dev/null || grim ~/Pictures/Screenshots/$(date +%Y%m%d-%H%M%S).png; wl-copy < $(ls -t ~/Pictures/Screenshots/*.png | head -n1) || true"), { locked = true })

-- Clipboard history (Noctalia panel; cliphist CLI as fallback)
hl.bind(mod .. " + SHIFT + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard 2>/dev/null || (cliphist list | head -n 20) || true"))

-- Interactive region screenshot (Satty annotation; graceful if not installed)
hl.bind("CTRL + P", hl.dsp.exec_cmd("uwsm app -- /home/yp/.local/bin/screenshot-satty region"))
hl.bind("CTRL + SHIFT + P", hl.dsp.exec_cmd("uwsm app -- /home/yp/.local/bin/screenshot-satty full"))

-- Volume / brightness / media (Noctalia OSD + direct control)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up 5 2>/dev/null; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down 5 2>/dev/null; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia msg volume-mute 2>/dev/null; wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("noctalia msg mic-mute 2>/dev/null; wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up 2>/dev/null; brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down 2>/dev/null; brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
