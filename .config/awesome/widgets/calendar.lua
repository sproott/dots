local wibox = require('wibox')

local layout = require('util.layout')

return function(colors, fonts, spacing)
  local calendar_icon =
    wibox.widget.textbox(layout.create_span({color = colors.primary, font = fonts.icon, content = '󰃭'}))
  local calendar =
    wibox.widget.textclock(layout.create_span({color = colors.primary, font = fonts.widget, content = '%d.%m.%Y'}))

  local calendar_widget = {
    calendar_icon,
    layout.horizontal_spacer(spacing),
    calendar
  }

  return {widget = calendar_widget}
end

