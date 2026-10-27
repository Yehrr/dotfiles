-- ============================================================================ #
--                                   PROGRAMS                                   #
-- ============================================================================ #

-- ----------------------------------- MAIN ----------------------------------- #

local terminal = "alacritty"
local launcher = "noctalia msg panel-toggle launcher"
local fileManager = "thunar" -- TODO: switch to yazi ?
local screenshot = "noctalia msg screenshot-region"
local browserPerso = "firefox" -- --profile "/home/yehrol/.mozilla/firefox/4seUQjF1.Profile 1" # FIXME no way of doing this with new profile for now
-- $browserWork = firefox #-P "Work" # FIXME no way of doing this with new profile for now
local reloadHypr = "hyprctl reload && notify-send \"Hyprland configuration reloaded\""

-- ---------------------------------- DESKTOP --------------------------------- #
local openhue = "~/git/perso/openhue-cli/dist/openhue_linux_amd64_v1/openhue set room Chambre -b"
local brightness0 = "ddcutil setvcp 10 0 --display 1 & ddcutil setvcp 10 0 --display 2 & ddcutil setvcp 10 0 --display 3"
local brightness1 = "ddcutil setvcp 10 20 --display 1 & ddcutil setvcp 10 20 --display 2 & ddcutil setvcp 10 20 --display 3"
local brightness2 = "ddcutil setvcp 10 40 --display 1 & ddcutil setvcp 10 40 --display 2 & ddcutil setvcp 10 40 --display 3"

-- ============================================================================ #
--                                   KEYBINDS                                   #
-- ============================================================================ #

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- ---------------------------- LAUNCH APPLICATION ---------------------------- #
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(launcher))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browserPerso))
-- hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(browserWork))
hl.bind(mainMod .. " + CTRL + S", hl.dsp.exec_cmd(screenshot))

-- --------------------------- MINI KEYBOARD CONTROL -------------------------- #
hl.bind(mainMod .. " + CTRL + ALT + 1", hl.dsp.exec_cmd(brightness0))
hl.bind(mainMod .. " + CTRL + ALT + 2", hl.dsp.exec_cmd(brightness1))
hl.bind(mainMod .. " + CTRL + ALT + 3", hl.dsp.exec_cmd(brightness2))
-- hl.bind(mainMod .. " + CTRL + ALT + 4", hl.dsp.exec_cmd("~/git/dmh.sh"))
hl.bind(mainMod .. " + CTRL + ALT + 5", hl.dsp.exec_cmd(openhue .. " 1"))
hl.bind(mainMod .. " + CTRL + ALT + 6", hl.dsp.exec_cmd(openhue .. " 50"))
hl.bind(mainMod .. " + CTRL + ALT + 7", hl.dsp.exec_cmd(openhue .. " 80"))
hl.bind(mainMod .. " + CTRL + ALT + 8", hl.dsp.exec_cmd(openhue .. " 100"))
-- 9 : last button on third row. the 3 before are media control
hl.bind(mainMod .. " + CTRL + ALT + 9", hl.dsp.exec_cmd(reloadHypr))

-- ----------------------------------- AUDIO ---------------------------------- #
-- bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+
-- bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-
-- bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up 2"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down 2"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia msg volume-mute"), { locked = true, repeating = true })

-- -------------------------------- BRIGHTNESS -------------------------------- #
-- bindel = ,XF86MonBrightnessUp, exec, brightnessctl s 10%+
-- bindel = ,XF86MonBrightnessDown, exec, brightnessctl s 10%-
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up 5"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down 5"), { locked = true, repeating = true })

-- --------------------------- MEDIA PLAYER CONTROL --------------------------- #
-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- ---------------------------- WINDOW MANIPULATION --------------------------- #
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.kill())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + W", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

-- Move focus with mainMod + vim control
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Move active window with mainMod + SHIFT + vim control
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))

-- Resize active window with mainMod + CTRL + vim control
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { locked = true, repeating = true })
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 30, y = 0, relative = true }), { locked = true, repeating = true })
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { locked = true, repeating = true })
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 30, relative = true }), { locked = true, repeating = true })

-- --------------------------------- WORKSPACE -------------------------------- #

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Switch workspaces with mainMod + [0-9]
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- Move active window to a workspace with mainMod + SHIFT + [0-9]
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Silently move active window to a workspace with mainMod + CTRL + [0-9]
-- bind = $mainMod CTRL, 1, movetoworkspacesilent, 1
-- bind = $mainMod CTRL, 2, movetoworkspacesilent, 2
-- bind = $mainMod CTRL, 3, movetoworkspacesilent, 3
-- bind = $mainMod CTRL, 4, movetoworkspacesilent, 4
-- bind = $mainMod CTRL, 5, movetoworkspacesilent, 5
-- bind = $mainMod CTRL, 6, movetoworkspacesilent, 6
-- bind = $mainMod CTRL, 7, movetoworkspacesilent, 7
-- bind = $mainMod CTRL, 8, movetoworkspacesilent, 8
-- bind = $mainMod CTRL, 9, movetoworkspacesilent, 9
-- bind = $mainMod CTRL, 0, movetoworkspacesilent, 10

-- Special workspace
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
