-- ============================================================================ #
--                                    MONITOR                                   #
-- ============================================================================ #

hl.monitor({
    output = "eDP-1",
    mode = "1920x1080",
    position = "0x0",
    scale = "1",
})

hl.monitor({
    output = "DP-1",
    mode = "2560x1440", -- no 165hz
    position = "1920x0",
    scale = "1",
})

hl.monitor({
    output = "HDMI-A-1",
    mode = "2560x1440", -- no 165hz
    position = "4480x0",
    scale = "1",
})

-- default
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "1",
})

-- ============================================================================ #
--                                   WORKSPACE                                  #
-- ============================================================================ #

-- only if main monitor off
hl.workspace_rule({workspace="1", monitor="DP-1", persistent=true})
hl.workspace_rule({workspace="2", monitor="DP-1", persistent=true})
hl.workspace_rule({workspace="3", monitor="DP-1", persistent=true})
hl.workspace_rule({workspace="4", monitor="DP-1", persistent=true})
hl.workspace_rule({workspace="5", monitor="DP-1", persistent=true})

hl.workspace_rule({workspace="6", monitor="HDMI-A-1", persistent=true})
hl.workspace_rule({workspace="7", monitor="HDMI-A-1", persistent=true})
hl.workspace_rule({workspace="8", monitor="HDMI-A-1", persistent=true})
hl.workspace_rule({workspace="9", monitor="HDMI-A-1", persistent=true})
hl.workspace_rule({workspace="10", monitor="HDMI-A-1", persistent=true})