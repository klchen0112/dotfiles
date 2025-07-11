#!/usr/bin/env lua

print("🔍 Loading items/init.lua")

-- Load window manager configuration

require("items.apple")

print("🚀 Loading aerospace spaces configuration")
require("items.spaces-aerospace")
print("🚀 Loading front_app configuration")
require("items.front_app")
print("🚀 Loading today configuration")
require("items.today")
require("items.media")
require("items.control_center")
require("items.stats")
