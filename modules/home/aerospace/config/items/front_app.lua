#!/usr/bin/env lua

local settings = require("settings")
local icons = require("icons")
local colors = require("colors")
local app_icons = require("app_icons")

-- local dm_status = Sbar.add("item", "dm.status", {
-- 	icon = {
-- 		color = colors.peach,
-- 		font = {
-- 			family = settings.font,
-- 			size = 16.0,
-- 			style = "Bold",
-- 		},
-- 		width = 30,
-- 		string = icons.yabai.grid,
-- 	},
-- 	label = { drawing = false },
-- })

-- dm_status:subscribe("front_app_switched", function()
-- 	Sbar.exec("aerospace list-modes --current", function(mode)
-- 		local stackIndex = tonumber(window["stack-index"])
-- 		local isFloating = window["is-floating"]

-- 		if stackIndex and stackIndex > 0 then
-- 			Sbar.exec("yabai -m query --windows --window stack.last", function(lastWindow)
-- 				local lastStackIndex = tonumber(lastWindow["stack-index"])

-- 				dm_status:set({
-- 					icon = {
-- 						string = icons.yabai.stack,
-- 						color = colors.red,
-- 					},
-- 					label = {
-- 						string = string.format("[%s/%s]", stackIndex, lastStackIndex),
-- 						drawing = true,
-- 					},
-- 				})

-- 				Sbar.exec("borders active_color=" .. COLOR_TO_HEX(colors.red))
-- 			end)
-- 		else
-- 			if isFloating == true then
-- 				dm_status:set({
-- 					icon = {
-- 						string = icons.yabai.float,
-- 						color = colors.maroon,
-- 					},
-- 				})
-- 			elseif window["has-fullscreen-zoom"] == true then
-- 				dm_status:set({
-- 					icon = {
-- 						string = icons.yabai.fullscreen_zoom,
-- 						color = colors.green,
-- 					},
-- 				})
-- 			elseif window["has-parent-zoom"] == true then
-- 				dm_status:set({
-- 					icon = {
-- 						string = icons.yabai.parent_zoom,
-- 						color = colors.blue,
-- 					},
-- 				})
-- 			else
-- 				yabai:set({
-- 					icon = {
-- 						string = icons.yabai.grid,
-- 						color = colors.peach,
-- 					},
-- 				})
-- 			end
-- 		end

-- 		yabai:set({
-- 			label = {
-- 				drawing = false,
-- 			},
-- 		})

-- 		Sbar.exec("borders active_color=" .. COLOR_TO_HEX(colors.blue))
-- 	end)
-- end)

local front_app = Sbar.add("item", "front_app", {
	icon = {
		drawing = true,
		font = {
			family = settings.app_font,
			style = "Regular",
			size = 16.0,
		},
	},
	background = {
		padding_left = 0,
	},
	display = "active",
	label = {
		color = colors.text,
		font = {
			family = settings.font,
			style = "Black",
			size = 12.0,
		},
	},
})

front_app:subscribe("front_app_switched", function(env)
	local window_name = env.INFO

	local window_rewrite_map = {
		["wezterm-gui"] = "WezTerm",
	}

	if window_rewrite_map[window_name] then
		window_name = window_rewrite_map[window_name]
	end
	local lookup = app_icons[window_name]
	local icon_text = ((lookup == nil) and app_icons["Default"] or lookup)
	front_app:set({
		icon = {
			string = icon_text,
		},
		label = {
			string = window_name,
		},
	})
end)
