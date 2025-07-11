#!/usr/bin/env lua

local colors = require("colors")
local app_icons = require("app_icons")
local settings = require("settings")

local spaces = {}
Sbar.exec('aerospace list-workspaces --all --format "%{workspace} %{monitor-id}"', function(sid_monitor_id)
	local sid, monitor_id = sid_monitor_id:match("(%d+) (%d+)")
	sid = tonumber(sid)
	monitor_id = tonumber(monitor_id)
	local space = Sbar.add("item", "space." .. tostring(sid) ,{
		position = "left",
		icon = {
			string = tostring(sid),
			padding_left = 7,
			padding_right = 7,
			color = colors.text,
			highlight_color = colors.dark_text,
			font = { family = settings.font,style = "Regular", size = 14,},
			align = "center",
		},
		display=monitor,
		padding_left = 2,
		padding_right = 2,
		label = {
			padding_left = 6,
			padding_right = 12,
			color = colors.light_text,
			highlight_color = colors.dark_text,
			font = {
				family = settings.app_font,
				style = "Regular",
				size = 16.0
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
			border_color = colors,
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
		display=monitor_id,
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
		local focused_num = tonumber(env.FOCUSED)
		local is_focused = focused_num == sid
		local color = is_focused and colors.white or colors.comment_bg
		local bg_color = is_focused and colors.selection_bg or colors.light_bg

		space:set({
			icon = { highlight = is_focused ,},
			label = { highlight = is_focused ,},
			background = { border_color = color ,
                       color = bg_color,
        },
		})
	end)

	space:subscribe("mouse.clicked", function(env)
		if env.BUTTON == "other" then
			space_popup:set({
				background = {
					image = "space." .. i,
				},
			})
			space:set({ popup = { drawing = "toggle" } })
		elseif env.BUTTON == "left" then
			Sbar.exec("aerospace workspace " .. i)
		elseif env.BUTTON == "right" then
			-- TODO: destroy / create?
			-- For right-click, just focus the workspace
			Sbar.exec("aerospace workspace " .. i)
		end
	end)

	space:subscribe("mouse.exited", function(_)
		space:set({ popup = { drawing = false } })
	end)
end)


local window_tracker = Sbar.add("item","separator_left", {
	padding_left = 10,
	padding_right = 8,
	icon = {
		string = "",
	},
	label = { drawing = false },
	associated_display = "active",
})

window_tracker:subscribe("aerospace_workspace_change", function()
	Sbar.exec('aerospace list-workspaces --all --format "%{workspace}"',function(workspace_num)
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

			if no_app then
				icon_line = ""
				spaces[workspace_num]:set({ drawing=false,label = { string = icon_line} })
			end

			-- Update the workspace label with app icons
			if spaces[workspace_num] then
				spaces[workspace_num]:set({ drawing=true,label = { string = icon_line } })
			end
		end)
	end)
end)
