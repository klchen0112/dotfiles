#!/usr/bin/env lua

local settings = require("settings")
local icons = require("icons")
local colors = require("colors")
local app_icons = require("app_icons")

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
