-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

require("lib.hostname")
local hostname = getHostnameSuffix() 

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("uwsm app -- noctalia")
    hl.exec_cmd("uwsm app -- udiskie")
    hl.exec_cmd("sleep 2 && uwsm app -- nextcloud") -- forced to sleep to appear in tray
    hl.exec_cmd("sleep 2 && uwsm app -- keepassxc") -- forced to sleep to appear in tray
    -- hl.exec_cmd("uwsm app -- solaar -w hide")
    -- hl.exec_cmd("systemctl --user start hyprpolkitagent")
    -- hl.exec_cmd("systemctl start input-remapper")
end)

-- DESKTOP ONLY
if hostname == "desktop" then
    hl.on("hyprland.start", function()
        hl.exec_cmd("firefox", { workspace = "1" })
        hl.exec_cmd("spotify-launcher", { workspace = "6 silent" }) -- feishin
        hl.exec_cmd("thunderbird", { workspace = "7 silent" })
        hl.exec_cmd("sleep 2 && vesktop --start-minimized", { workspace = "8 silent" }) -- forced to sleep to appear in tray
    end)
end
