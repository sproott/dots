-- Standard awesome library
local gears = require("gears")
local wibox = require("wibox")

local padding = wibox.widget.textbox("    ")

local layout = {padding = padding}

layout.pad = function(widgets)
  return gears.table.join({padding}, widgets, {padding})
end

layout.fixed_horizontal = function(widgets)
  return gears.table.join({layout = wibox.layout.fixed.horizontal}, widgets)
end

return layout
