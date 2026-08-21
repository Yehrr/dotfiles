-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

require("lib.hostname")
local hostname = getHostnameSuffix() 

if hostname == "desktop" then
	require("config.monitor-desktop")
elseif hostname == "laptop" then
	require("config.monitor-laptop")
else
	-- TODO error notif ?
end

require("config.autostart")
-- require("config.environment") -- Only when not using uwsm
require("config.esthetic")
require("config.feel")
require("config.input")
require("config.keybinds")
require("config.rules")
