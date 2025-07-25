#!/usr/bin/env lua

local colors = require("colors")
local app_icons = require("app_icons")
local icons = require("icons")
-- local dm_mode_status = Sbar.add("item", "aerospace.mode.status", {
-- 	icon = {
-- 		color = colors.peach,
-- 		font = {
-- 			family = settings.nerd_font,
-- 			size = 16.0,
-- 			style = "Bold",
-- 		},
-- 		width = 30,
-- 		string = icons.aerospace.main,
-- 	},
-- 	label = { drawing = false },
-- })

-- dm_mode_status:subscribe("aerospace_mode_change", function(env)
--         local mode = env.MODE
--         local icon_s = icons.aerospace.main
--         if mode == "service" then
--             icon_s = icons.aerospace.service
--         else if mode == "resize" then
--             icon_s = icons.aerospace.resize
--         end
--         dm_mode_status.set({
--                 icon ={string =icon_s, }
--         })
-- end)

local settings = require("settings")

local spaces = {}
for sid = 1, 10 do
    local space = Sbar.add("item", "space." .. tostring(sid), {
        position = "left",
        icon = {
            string = tostring(sid),
            padding_left = 7,
            padding_right = 7,
            color = colors.text,
            highlight_color = colors.light_text,
            font = { family = settings.font, style = "Regular", size = 14 },
            align = "center",
        },
        padding_left = 2,
        padding_right = 2,
        label = {
            padding_left = 6,
            padding_right = 12,
            color = colors.text,
            highlight_color = colors.light_text,
            font = {
                family = settings.app_font,
                style = "Regular",
                size = 16.0,
            },
            y_offset = -1,
            background = {
                height = 26,
                drawing = true,
                color = colors.light_bg,
                corner_radius = 8,
            },
        },
        background = {
            drawing = true,
            color = colors.light_bg,
            border_color = colors.comment_bg,
            border_width = 2,
            corner_radius = 8,
        },
        popup = {
            background = {
                border_width = 5,
            },
        },
    })

    spaces[sid] = space

    local space_popup = Sbar.add("item", {
        position = "popup." .. space.name,
        padding_left = 5,
        padding_right = 0,
        background = {
            drawing = true,
            image = {
                corner_radius = 9,
                scale = 0.2,
            },
        },
    })

    -- Subscribe to aerospace workspace change for focus updates
    space:subscribe("aerospace_workspace_change", function(env)
        local focused_num = tonumber(env.FOCUSED_WORKSPACE)
        local is_focused = focused_num == sid
        local color = is_focused and colors.blue or colors.comment_bg
        local bg_color = is_focused and colors.selection_bg or colors.comment_bg

        space:set({
            icon = { highlight = is_focused },
            label = { highlight = is_focused },
            background = { border_color = color, color = bg_color },
        })
    end)

    space:subscribe("mouse.clicked", function(env)
        if env.BUTTON == "other" then
            space_popup:set({
                background = {
                    image = "space." .. sid,
                },
            })
            space:set({ popup = { drawing = "toggle" } })
        elseif env.BUTTON == "left" then
            Sbar.exec("aerospace workspace " .. sid)
        elseif env.BUTTON == "right" then
            -- TODO: destroy / create?
            -- For right-click, just focus the workspace
            Sbar.exec("aerospace workspace " .. sid)
        end
    end)

    space:subscribe("mouse.exited", function(_)
        space:set({ popup = { drawing = false } })
    end)
end

local window_tracker = Sbar.add("item", "separator_left", {
    padding_left = 10,
    padding_right = 8,
    icon = {
        string = "",
    },
    label = { drawing = false },
    associated_display = "active",
})

window_tracker:subscribe("aerospace_workspace_change", function()
    for workspace_num = 1, 10 do
        Sbar.exec("aerospace list-windows --workspace " .. workspace_num .. ' --format "%{app-name}"', function(result)
            local icon_line = ""
            local no_app = true

            if result and result ~= "" then
                local apps = {}
                for app in result:gmatch("[^\n]+") do
                    if app and app ~= "" and app ~= "None" then
                        apps[app] = true -- Use as set to avoid duplicates
                    end
                end

                -- Convert to icon line
                for app, _ in pairs(apps) do
                    no_app = false
                    local lookup = app_icons[app]
                    local icon = ((lookup == nil) and app_icons["Default"] or lookup)
                    icon_line = icon_line .. " " .. icon
                end
            end

            -- Update the workspace label with app icons
            if spaces[workspace_num] then
                spaces[workspace_num]:set({ drawing = not no_app, label = { string = icon_line } })
            end
        end)
    end
end)
