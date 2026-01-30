local hotkey = require("hs.hotkey")
local task = require("hs.task")
local alert = require("hs.alert")
-- Spawn a new emacs client
local function newEmacsClient()
    alert.show("New Emacs client!")
    task.new("/bin/zsh", nil, { "-l", "-c", 'emacsclient -a "" -c' }):start()
end

hs.hotkey.bind({ "ctrl", "cmd", "shift" }, "e", function()
    newEmacsClient()
end)
-- HammerSpoon menu bar item to show active Mission Control space.
-- Built-in and external display names are shown. Spaces are listed in order per display. Active space is square bracketed.
ActiveSpace = hs.loadSpoon("ActiveSpace")
ActiveSpace:start()
-- Warp the mouse cursor from the edge of one screen to the edge of another screen to simulate external monitors being placed side by side.
WarpMouse = hs.loadSpoon("WarpMouse")
WarpMouse:start()

PaperWM = hs.loadSpoon("PaperWM")
-- Start of PaperWM Ignore Apps
-- PaperWM.window_filter:allowApp("Emacs")
-- PaperWM.window_filter:setAppFilter("Emacs", {
--     visible   = true,
--     fullscreen = false,
--     hasTitlebar = true,
--     allowRoles = "AXWindow"   -- 只影响 Emacs
-- })
PaperWM.window_filter:rejectApp("iStat Menus Status") -- ignore a specific app
PaperWM.window_filter:rejectApp("Finder")
PaperWM.window_filter:rejectApp("ActivityMonitor")
PaperWM.window_filter:rejectApp("BitWarden")
-- End of PaperWM Ignore Apps
PaperWM.window_gap = { top = 4, bottom = 4, left = 4, right = 4 } -- Specific gaps per side
PaperWM:bindHotkeys({
    -- switch to a new focused window in tiled grid
    focus_left = { { "alt" }, "left" },
    focus_right = { { "alt" }, "right" },
    focus_up = { { "alt" }, "up" },
    focus_down = { { "alt" }, "down" },

    -- switch windows by cycling forward/backward
    -- (forward = down or right, backward = up or left)
    focus_prev = { { "alt", "cmd" }, "k" },
    focus_next = { { "alt", "cmd" }, "j" },

    -- move windows around in tiled grid
    swap_left = { { "alt", "shift" }, "left" },
    swap_right = { { "alt", "shift" }, "right" },
    swap_up = { { "alt", "shift" }, "up" },
    swap_down = { { "alt", "shift" }, "down" },
    -- move focused window into / out of a column
    slurp_in = { { "alt", "shift" }, "i" },
    barf_out = { { "alt", "shift" }, "o" },
    -- alternative: swap entire columns, rather than
    -- individual windows (to be used instead of
    -- swap_left / swap_right bindings)
    swap_column_left = { { "alt", "shift", "ctrl" }, "left" },
    swap_column_right = { { "alt", "shift", "ctrl" }, "right" },

    -- position and resize focused window
    center_window = { { "ctrl", "cmd" }, "c" },
    full_width = { { "ctrl", "cmd" }, "f" },
    cycle_width = { { "ctrl", "cmd" }, "r" },
    reverse_cycle_width = { { "alt", "shift" }, "r" },
    cycle_height = { { "alt", "shift" }, "r" },
    reverse_cycle_height = { { "ctrl", "alt", "shift" }, "r" },

    -- increase/decrease width
    increase_width = { { "ctrl", "cmd" }, "=" },
    decrease_width = { { "ctrl", "cmd" }, "-" },
    increase_height = { { "alt", "shift" }, "=" },
    decrease_height = { { "alt", "shift" }, "-" },

    -- move the focused window into / out of the tiling layer
    toggle_floating = { { "alt", "shift" }, "escape" },

    -- focus the first / second / etc window in the current space
    focus_window_1 = { { "ctrl", "cmd" }, "1" },
    focus_window_2 = { { "ctrl", "cmd" }, "2" },
    focus_window_3 = { { "ctrl", "cmd" }, "3" },
    focus_window_4 = { { "ctrl", "cmd" }, "4" },
    focus_window_5 = { { "ctrl", "cmd" }, "5" },
    focus_window_6 = { { "ctrl", "cmd" }, "6" },
    focus_window_7 = { { "ctrl", "cmd" }, "7" },
    focus_window_8 = { { "ctrl", "cmd" }, "8" },
    focus_window_9 = { { "ctrl", "cmd" }, "9" },

    -- switch to a new Mission Control space
    switch_space_l = { { "alt", "ctrl" }, "," },
    switch_space_r = { { "alt", "ctrl" }, "." },
    switch_space_1 = { { "alt", "ctrl" }, "1" },
    switch_space_2 = { { "alt", "ctrl" }, "2" },
    switch_space_3 = { { "alt", "ctrl" }, "3" },
    switch_space_4 = { { "alt", "ctrl" }, "4" },
    switch_space_5 = { { "alt", "ctrl" }, "5" },
    switch_space_6 = { { "alt", "ctrl" }, "6" },
    switch_space_7 = { { "alt", "ctrl" }, "7" },
    switch_space_8 = { { "alt", "ctrl" }, "8" },
    switch_space_9 = { { "alt", "ctrl" }, "9" },

    -- move focused window to a new space and tile
    move_window_1 = { { "alt", "shift" }, "1" },
    move_window_2 = { { "alt", "shift" }, "2" },
    move_window_3 = { { "alt", "shift" }, "3" },
    move_window_4 = { { "alt", "shift" }, "4" },
    move_window_5 = { { "alt", "shift" }, "5" },
    move_window_6 = { { "alt", "shift" }, "6" },
    move_window_7 = { { "alt", "shift" }, "7" },
    move_window_8 = { { "alt", "shift" }, "8" },
    move_window_9 = { { "alt", "shift" }, "9" },
})
PaperWM:start() -- restart for new window filter to take effect

-- focus adjacent window with 3 finger swipe
local current_id, threshold
Swipe = hs.loadSpoon("Swipe")
Swipe:start(3, function(direction, distance, id)
    if id == current_id then
        if distance > threshold then
            threshold = math.huge -- trigger once per swipe

            -- use "natural" scrolling
            if direction == "left" then
                PaperWM.actions.focus_left()
            elseif direction == "right" then
                PaperWM.actions.focus_right()
            elseif direction == "up" then
                PaperWM.actions.focus_up()
            elseif direction == "down" then
                PaperWM.actions.focus_down()
            end
        end
    else
        current_id = id
        threshold = 0.2 -- swipe distance > 20% of trackpad size
    end
end)
