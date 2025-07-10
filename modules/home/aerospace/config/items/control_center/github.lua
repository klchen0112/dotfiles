#!/usr/bin/env lua

local icons = require("icons")
local settings = require("settings")
local colors = require("colors")

local popup_off = "sketchybar --set github popup.drawing=off"

local github = Sbar.add("item", "github", {
	position = "right",
	icon = {
		string = icons.bell,
		color = colors.blue,
		font = {
			family = settings.font,
			style = "Bold",
			size = 15.0,
		},
	},
	background = {
		padding_left = 0,
	},
	label = {
		string = icons.loading,
		highlight_color = colors.blue,
	},
	update_freq = 180,
	popup = {
		align = "right",
	},
})

github.details = Sbar.add("item", "github.details", {
	position = "popup." .. github.name,
	click_script = popup_off,
	background = {
		corner_radius = 12,
		padding_left = 7,
		padding_right = 7,
	},
	icon = {
		background = {
			height = 2,
			y_offset = -12,
		},
	},
})

github:subscribe({
	"mouse.clicked",
}, function(info)
	if info.BUTTON == "left" then
		POPUP_TOGGLE(info.NAME)
	end

	if info.BUTTON == "right" then
		Sbar.trigger("github_update")
	end
end)

github:subscribe({
	"mouse.exited",
	"mouse.exited.global",
}, function(_)
	github:set({ popup = { drawing = false } })
end)

github:subscribe({
	"mouse.entered",
}, function(_)
	github:set({ popup = { drawing = true } })
end)

github:subscribe({
	"routine",
	"forced",
	"github_update",
}, function(_)
	-- fetch new information
	Sbar.exec("gh api notifications", function(notifications)
		-- Clear existing packages
		local existingNotifications = github:query()
		if existingNotifications.popup and next(existingNotifications.popup.items) ~= nil then
			for _, item in pairs(existingNotifications.popup.items) do
				Sbar.remove(item)
			end
		end

		-- PRINT_TABLE(notifications)

		local count = 0
		for _, notification in pairs(notifications) do
			-- PRINT_TABLE(notification)
			-- increment count for label
			count = count + 1

			local id = notification.id
			local url = notification.subject.latest_comment_url or notification.subject.url
			local repo = notification.repository.name
			local title = notification.subject.title
			local type = notification.subject.type

			-- set click_script for each notification
			if url == nil then
				url = "https://www.github.com/notifications"
			else
				local tempUrl = url:gsub("^'", ""):gsub("'$", "")
				Sbar.exec('gh api "' .. tempUrl .. '" | jq .html_url', function(html_url)
					local cmd = "sketchybar -m --set github.notification"

					if IS_EMPTY(repo) == false then
						cmd = cmd .. ".repo."
						cmd = cmd .. tostring(id) .. ' click_script="open ' .. html_url .. '"'
						Sbar.exec(cmd, function()
							Sbar.exec(popup_off)
						end)
					end

					cmd = "sketchybar -m --set github.notification"
					if IS_EMPTY(title) == false then
						cmd = cmd .. ".message."
						cmd = cmd .. tostring(id) .. ' click_script="open ' .. html_url .. '"'
						Sbar.exec(cmd, function()
							Sbar.exec(popup_off)
						end)
					end
				end)
			end

			-- get icon and color for each notification
			-- depending on the type
			local color, icon
			if type == "Issue" then
				color = colors.green
				icon = icons.git.issue
			elseif type == "Discussion" then
				color = colors.text
				icon = icons.git.discussion
			elseif type == "PullRequest" then
				color = colors.maroon
				icon = icons.git.pull_request
			elseif type == "Commit" then
				color = colors.text
				icon = icons.git.commit
			else
				color = colors.text
				icon = icons.git.issue
			end

			-- add notification to popup
			github.notification = {}

			if IS_EMPTY(repo) == false then
				github.notification.repo = Sbar.add("item", "github.notification.repo." .. tostring(id), {
					label = {
						padding_right = settings.paddings,
					},
					icon = {
						string = icon .. " " .. repo,
						color = color,
						font = {
							family = settings.nerd_font,
							size = 14.0,
							style = "Bold",
						},
						padding_left = settings.paddings,
					},
					drawing = true,
					-- TODO: trigger update after clicking since notification is cleared on github
					click_script = "open " .. url .. "; " .. popup_off,
					position = "popup." .. github.name,
				})
			end

			if IS_EMPTY(title) == false then
				github.notification.message = Sbar.add("item", "github.notification.message." .. tostring(id), {
					label = {
						string = title,
						padding_right = 10,
					},
					icon = {
						drawing = "off",
						padding_left = settings.paddings,
					},
					drawing = true,
					-- TODO: trigger update after clicking since notification is cleared on github
					click_script = "open " .. url .. "; " .. popup_off,
					position = "popup." .. github.name,
				})
			end
		end

		-- Change icon and color depending on packages
		github:set({
			icon = {
				string = icons.bell_dot,
			},
			label = 0,
		})

		if count > 0 then
			github:set({
				icon = {
					string = icons.bell,
				},
				label = count,
			})
		end
	end)
end)

return github
