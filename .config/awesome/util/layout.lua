-- Standard awesome library
local gears = require("gears")
local wibox = require("wibox")

local padding = wibox.widget.textbox("    ")

local layout = {padding = padding}

layout.pad = function(widgets)
  return gears.table.join({padding}, widgets, {padding})
end

return layout
