#!/usr/bin/env lua

local colors = require("colors")

Sbar.add("item", "skhd", {
	icon = {
		string = "N",
		color = colors.blue,
		padding_left = 10,
		padding_right = 5,
	},
	background = {
		color = colors.light_bg,
		border_color = colors.comment_bg,
		border_width = 2,
	},
	drawing = false,
	position = "left",
})
