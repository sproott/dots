local gears = require("gears")
local wibox = require("wibox")

local layout = {}

layout.fixed_horizontal = function(widgets)
  return gears.table.join({layout = wibox.layout.fixed.horizontal}, widgets)
end

layout.add_padding = function(widgets, padding)
  return {
    widgets,
    top = padding.top or 0,
    right = padding.right or 0,
    bottom = padding.bottom or 0,
    left = padding.left or 0,
    widget = wibox.container.margin,
  }
end

layout.horizontal_spacer = function(spacing)
  return {
    left = spacing,
    widget = wibox.container.margin,
  }
end

layout.create_span = function(params)
  return '<span color="'..params.color..'" font="'..params.font..'">'..params.content..'</span>'
end

return layout
