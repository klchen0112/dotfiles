-- HammerSpoon menu bar item to show active Mission Control space.
-- Built-in and external display names are shown. Spaces are listed in order per display. Active space is square bracketed.
local ActiveSpace = hs.loadSpoon("ActiveSpace")
ActiveSpace:start()
-- Warp the mouse cursor from the edge of one screen to the edge of another screen to simulate external monitors being placed side by side.
local WarpMouse = hs.loadSpoon("WarpMouse")
WarpMouse:start()

local PaperWM = hs.loadSpoon("PaperWM")
-- focus adjacent window with 3 finger swipe
local current_id, threshold
Swipe = hs.loadSpoon("Swipe")
