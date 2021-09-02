-- Standard awesome library
local gears = require("gears")
local wibox = require("wibox")

local layout = {}

layout.padding = wibox.widget.textbox("    ")

local padding = {layout.padding}

layout.pad = function(widgets)
  return gears.table.join(padding, widgets, padding)
end

return layout
