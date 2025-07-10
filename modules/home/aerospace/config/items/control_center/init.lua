#!/usr/bin/env lua

local colors = require("colors")

-- require order determines ui order on bar
local battery = require("items.control_center.battery")
local wifi = require("items.control_center.wifi")
local bluetooth = require("items.control_center.bluetooth")
local brew = require("items.control_center.brew")
local github = require("items.control_center.github")
local volume = require("items.control_center.volume")

local items = {
	battery.name,
	wifi.name,
	bluetooth.name,
	brew.name,
	github.name,
	volume.icon.name,
}

Sbar.add("bracket", items, {
	background = {
		color = colors.light_bg,
		border_color = colors.comment_bg,
		border_width = 2,
		padding_left = 5,
		padding_right = 10,
	},
})
