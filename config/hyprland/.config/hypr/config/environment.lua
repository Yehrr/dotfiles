-- ---------------------------------- GENERAL --------------------------------- #

hl.env("SSH_AUTH_SOCK", "$XDG_RUNTIME_DIR/ssh-agent.socket")

-- hl.env("XCURSOR_SIZE", "24")

-- XDG specifications
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Graphics optimizations
-- hl.env("WLR_RENDERER", "vulkan")
-- hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
-- hl.env("LIBVA_DRIVER_NAME", "radeonsi")

-- hl.env("QT_QPA_PLATFORMTHEME", "gtk3")

-- --------------------------------- HYPRLAND --------------------------------- #
hl.env("HYPRCURSOR_SIZE", "24")
